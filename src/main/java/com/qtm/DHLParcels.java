/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.qtm;

import java.util.List;

/**
 *
 * @author Administrator
 */
public class DHLParcels {

    private List<DHLParcel> arrivedChina;
    private List<DHLParcel> notarrivedChina;

    public List<DHLParcel> getArrivedChina() {
        return arrivedChina;
    }

    public void setArrivedChina(List<DHLParcel> arrivedChina) {
        this.arrivedChina = arrivedChina;
    }

    public List<DHLParcel> getNotarrivedChina() {
        return notarrivedChina;
    }

    public void setNotarrivedChina(List<DHLParcel> notarrivedChina) {
        this.notarrivedChina = notarrivedChina;
    }

}
