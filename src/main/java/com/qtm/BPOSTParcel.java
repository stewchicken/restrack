/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.qtm;

/**
 *
 * @author Administrator
 */
public class BPOSTParcel {
    
    private String bpostcode;
    private String emscode;
    private String status;
    private String bposttrackurl;
    private String bposttrackurlchinese;

    public String getBpostcode() {
        return bpostcode;
    }

    public void setBpostcode(String bpostcode) {
        this.bpostcode = bpostcode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBposttrackurl() {
        return bposttrackurl;
    }

    public void setBposttrackurl(String bposttrackurl) {
        this.bposttrackurl = bposttrackurl;
    }

    public String getBposttrackurlchinese() {
        return bposttrackurlchinese;
    }

    public void setBposttrackurlchinese(String bposttrackurlchinese) {
        this.bposttrackurlchinese = bposttrackurlchinese;
    }

    public String getEmscode() {
        return emscode;
    }

    public void setEmscode(String emscode) {
        this.emscode = emscode;
    }
    
    
}
