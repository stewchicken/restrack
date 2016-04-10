package com.qtm.rest;

import com.qtm.ALLParcels;
import com.qtm.BPOSTParcel;
import com.qtm.BPOSTParcels;
import com.qtm.DHLParcel;
import com.qtm.DHLParcels;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URI;
import java.net.URLEncoder;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import static org.apache.http.HttpHeaders.USER_AGENT;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.HttpClientUtils;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 *
 * @author Administrator
 */
@Path("/query")
public class Query {

    final static Logger logger = Logger.getLogger(Query.class);
    private static String bposturl = "http://www.bpost2.be/bpi/track_trace/find.php";
    private static String dhlurl = "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?";
    String dhltracklink = "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=en&idc=dhlcode&rfn=&extendedSearch=true";
    String bposttracklink = "http://track.bpost.be/etr/light/showSearchPage.do?oss_language=EN";
    String googledtracklink = "https://translate.google.com/translate?sl=en&tl=zh-CN&js=y&prev=_t&hl=en&ie=UTF-8&u=tracklink";
    private final static String NOT_ARRIVED = " NOT_ARRIVED CHINA";
    private final static String ARRIVED = " ARRIVED IN CHINA ";
    private final static String NO_EMS = " EMS  NOT GENERATED YET  ";
    private final static String NO_CHINAPOST = " CHINAPOST NOT GENERATED YET";

    @POST
    @Path("/post")
    //@Produces(MediaType.APPLICATION_JSON )
    @Produces("application/json; charset=UTF-8")
    public ALLParcels getParcels(
            @FormParam("dhlcodes") String dhlcodes,
            @FormParam("bpostcodes") String bpostcodes) {

        long starttime = System.currentTimeMillis();

        ALLParcels allParcels = new ALLParcels();

        allParcels.setDhlParcels(getDHlParcels(dhlcodes));

        long currenttime = System.currentTimeMillis();

        logger.info("getDHLParcels spend" + (currenttime - starttime) / 1000 + " seconds");
        starttime = currenttime;
        allParcels.setBpostParcels(getBPOSTParcels(bpostcodes));
        currenttime = System.currentTimeMillis();
        logger.info("getBPOSTParcels spend  " + (currenttime - starttime) / 1000 + " seconds");
        return allParcels;
    }

    private DHLParcels getDHlParcels(String dhlcodes) {
        StringTokenizer st = new StringTokenizer(dhlcodes);
        LinkedList<String> dhlcodeList = new LinkedList<String>();
        DHLParcels dhlParcels = new DHLParcels();
        List<DHLParcel> arrivedChina = new LinkedList<DHLParcel>();
        List<DHLParcel> notarrivedChina = new LinkedList<DHLParcel>();

        dhlParcels.setNotarrivedChina(notarrivedChina);

        dhlParcels.setArrivedChina(arrivedChina);

        while (st.hasMoreTokens()) {
            dhlcodeList.add(st.nextToken());
        }
        for (String dhlcode : dhlcodeList) {
            getDHL(dhlcode, dhlcode, arrivedChina, notarrivedChina);
        }

        return dhlParcels;
    }

    private void getDHL(String initStatus, String dhlcode, List<DHLParcel> arrivedChinaList, List<DHLParcel> notarrivedChina) {
        String status = null;
        URIBuilder builder = new URIBuilder();
        HttpGet httpget = null;
        HttpClient client = null;
        builder.setScheme("https").setHost("nolp.dhl.de").setPath("/nextt-online-public/set_identcodes.do")
                .setParameter("lang", "en")
                .setParameter("idc", dhlcode)
                .setParameter("rfn", "")
                .setParameter("extendedSearch", "true");

        try {
            URI uri = builder.build();
            httpget = new HttpGet(uri);
            client = HttpClientBuilder.create().build();
            // add request header
            httpget.addHeader("User-Agent", USER_AGENT);
            HttpResponse response = client.execute(httpget);
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode != HttpStatus.SC_OK) {
                System.err.println("Method failed: " + statusCode);
            }
            BufferedReader rd = new BufferedReader(
                    new InputStreamReader(response.getEntity().getContent()));
            StringBuffer result = new StringBuffer();
            String line = "";
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
            logger.debug(result);

            // Execute the method.
            /*
             if (statusCode != HttpStatus.SC_OK) {
             System.err.println("Method failed: " + method.getStatusLine());
             }*/
            String html = result.toString();

            boolean arrivedChina = false;
            if (html.contains("The shipment has arrived in the destination country") || html.contains("The shipment has been successfully delivered")) {
                arrivedChina = true;
            }

            org.jsoup.nodes.Document doc = Jsoup.parse(html);
            Elements elements = doc.select(":containsOwn(Domestic shipment number)");
            String chianPostNumber = null;
            if (elements.size() == 1) {
                org.jsoup.nodes.Element element = (org.jsoup.nodes.Element) elements.get(0);
                if (element.nextElementSibling().text().trim().length() > 1) {
                    chianPostNumber = element.nextElementSibling().text().trim();
                }
            }

            Elements timeelements = doc.select(":containsOwn(Status from)");
            String date = null;
            if (timeelements.size() != 0) {
                org.jsoup.nodes.Element element = (org.jsoup.nodes.Element) timeelements.get(0);
                date = ((String) element.text()).substring(16);
            }

            if (arrivedChina) {
                status = initStatus + ARRIVED + new java.sql.Date(System.currentTimeMillis());
                DHLParcel dhlParcel = new DHLParcel();
                dhlParcel.setDhlcode(dhlcode);
                dhlParcel.setChinapostcode(chianPostNumber);
                dhlParcel.setStatus(status);
                String dhlurl_tmp = dhltracklink;
                String googledhltracklink_tmp = googledtracklink;
                dhlurl_tmp = dhlurl_tmp.replace("dhlcode", dhlcode);
                googledhltracklink_tmp = googledhltracklink_tmp.replace("tracklink", URLEncoder.encode(dhlurl_tmp, "UTF-8"));
                dhlParcel.setDhlurl(dhlurl_tmp);
                dhlParcel.setDhlurlchinese(googledhltracklink_tmp);
                arrivedChinaList.add(dhlParcel);
            } else {
                DHLParcel dhlParcel = new DHLParcel();
                status = initStatus + NOT_ARRIVED;
                if (chianPostNumber != null) {
                    dhlParcel.setChinapostcode(chianPostNumber);
                } else {
                    status = status + NO_CHINAPOST;
                }
                dhlParcel.setDhlcode(dhlcode);
                dhlParcel.setStatus(status);
                String dhlurl_tmp = dhltracklink;
                String googledhltracklink_tmp = googledtracklink;
                dhlurl_tmp = dhlurl_tmp.replace("dhlcode", dhlcode);
                googledhltracklink_tmp = googledhltracklink_tmp.replace("tracklink", URLEncoder.encode(dhlurl_tmp, "UTF-8"));
                dhlParcel.setDhlurl(dhlurl_tmp);
                dhlParcel.setDhlurlchinese(googledhltracklink_tmp);
                notarrivedChina.add(dhlParcel);
            }

        } catch (Exception e) {
            logger.error(e);
        } finally {
            if (client != null) {
                HttpClientUtils.closeQuietly(client);
            }
        }

    }

    private BPOSTParcels getBPOSTParcels(String bpostcodes) {
        StringTokenizer st = new StringTokenizer(bpostcodes);
        LinkedList<String> bpostcodelist = new LinkedList<String>();
        BPOSTParcels bpostarcels = new BPOSTParcels();
        List<BPOSTParcel> arrivedChina = new LinkedList<BPOSTParcel>();
        List<BPOSTParcel> notarrivedChina = new LinkedList<BPOSTParcel>();

        bpostarcels.setNotarrivedChina(notarrivedChina);

        bpostarcels.setArrivedChina(arrivedChina);

        while (st.hasMoreTokens()) {
            bpostcodelist.add(st.nextToken());
        }
        for (String bpostcode : bpostcodelist) {
            getBPOSTParcel(bpostcode, bpostcode, arrivedChina, notarrivedChina);
        }

        return bpostarcels;
    }

    private void getBPOSTParcel(String initStatus, String bpostcode, List<BPOSTParcel> arrivedChina, List<BPOSTParcel> notarrivedChina) {
        BPOSTParcel bpostParcel = new BPOSTParcel();
        String status = initStatus;
        int statusQuo = 0; // no ems , 1 is not arrive , 2 arrived
        // Create an instance of HttpClient.
        // "http://www.bpost2.be/bpi/track_trace/find.php";
        URIBuilder urlbuilder = new URIBuilder();
        HttpGet httpget = null;
        HttpClient client = null;
        urlbuilder.setScheme("http").setHost("www.bpost2.be").setPath("/bpi/track_trace/find.php")
                .setParameter("ing", "de")
                .setParameter("search", "s")
                .setParameter("trackcode", bpostcode);
        try {
            URI uri = urlbuilder.build();
            httpget = new HttpGet(uri);
            client = HttpClientBuilder.create().build();
            // add request header
            httpget.addHeader("User-Agent", USER_AGENT);
            HttpResponse response = client.execute(httpget);
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode != HttpStatus.SC_OK) {
                System.err.println("Method failed: " + statusCode);
            }
            BufferedReader rd = new BufferedReader(
                    new InputStreamReader(response.getEntity().getContent()));
            StringBuffer result = new StringBuffer();
            String line = "";
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
            logger.debug(result);
            // Read the response body.
            // Deal with the response.
            // Use caution: ensure correct character encoding and
            // is not binary data
            String xml = result.toString();
            String emsCode = null;
            if (xml.contains("relabelBarcode")) {
                // No mailout matches the barcode:
                DocumentBuilderFactory factory = DocumentBuilderFactory
                        .newInstance();
                DocumentBuilder builder = factory.newDocumentBuilder();
                Document document = builder.parse(new InputSource(
                        new StringReader(xml)));
                Element rootElement = document.getDocumentElement();
                emsCode = getString("relabelBarcode", rootElement);
                LinkedList<String> locations = getStrings("location",
                        rootElement);
                LinkedList<String> datetimes = getStrings("dateTime",
                        rootElement);

                statusQuo = 1;
                if (locations.size() > 0) {
                    for (String location : locations) {
                        if (location.toUpperCase().startsWith("CN") || location.toUpperCase().contains("CHINA")) {
                            status = status + ARRIVED
                                    + datetimes
                                    .get(locations.indexOf(location))
                                    + "EMS generated "
                                    + emsCode;
                            statusQuo = 2;
                            break;
                        }
                    }
                }
            }

            String bposturl_tmp = bposttracklink;
            String googledhltracklink_tmp = googledtracklink;
            googledhltracklink_tmp = googledhltracklink_tmp.replace("tracklink", URLEncoder.encode(bposturl_tmp, "UTF-8"));
            bpostParcel.setBpostcode(bpostcode);
            bpostParcel.setBposttrackurl(bposturl_tmp);
            bpostParcel.setBposttrackurlchinese(googledhltracklink_tmp);

            if (statusQuo == 0) {
                status = status + NOT_ARRIVED + NO_EMS;
                bpostParcel.setStatus(status);
                notarrivedChina.add(bpostParcel);
            } else if (statusQuo == 1) {
                status = status + NOT_ARRIVED + " EMS " + emsCode;
                bpostParcel.setStatus(status);
                bpostParcel.setEmscode(emsCode);
                notarrivedChina.add(bpostParcel);
            } else {
                bpostParcel.setStatus(status);
                bpostParcel.setEmscode(emsCode);
                arrivedChina.add(bpostParcel);
            }
        } catch (Exception e) {
            logger.error(e);
        } finally {
             if (client != null) {
                HttpClientUtils.closeQuietly(client);
            }
        }

    }

    protected static LinkedList getStrings(String tagName, Element element) {
        LinkedList strings = new LinkedList();
        NodeList list = element.getElementsByTagName(tagName);
        for (int i = 0; i < list.getLength(); i++) {
            if (list != null && list.getLength() > 0) {
                NodeList subList = list.item(i).getChildNodes();
                if (subList != null && subList.getLength() > 0) {
                    strings.add(subList.item(0).getNodeValue());
                }
            }
        }
        return strings;
    }

    protected static String getString(String tagName, Element element) {
        NodeList list = element.getElementsByTagName(tagName);
        if (list != null && list.getLength() > 0) {
            NodeList subList = list.item(0).getChildNodes();
            if (subList != null && subList.getLength() > 0) {
                return subList.item(0).getNodeValue();
            }
        }
        return null;
    }

}
