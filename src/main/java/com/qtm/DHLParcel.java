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
public class DHLParcel {
    
    private String dhlcode;
    private String chinapostcode;

    public String getChinapostcode() {
        return chinapostcode;
    }

    public void setChinapostcode(String chinapostcode) {
        this.chinapostcode = chinapostcode;
    }
    private String status;
    private String dhlurl;
    private String dhlurlchinese;

    public String getDhlcode() {
        return dhlcode;
    }

    public void setDhlcode(String dhlcode) {
        this.dhlcode = dhlcode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDhlurl() {
        return dhlurl;
    }

    public void setDhlurl(String dhlurl) {
        this.dhlurl = dhlurl;
    }

    public String getDhlurlchinese() {
        return dhlurlchinese;
    }

    public void setDhlurlchinese(String dhlurlchinese) {
        this.dhlurlchinese = dhlurlchinese;
    }
    
    
}
