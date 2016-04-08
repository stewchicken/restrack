/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.qtm;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class BPOSTParcels {

    public List<BPOSTParcel> getArrivedChina() {
        return arrivedChina;
    }

    public void setArrivedChina(List<BPOSTParcel> arrivedChina) {
        this.arrivedChina = arrivedChina;
    }

    public List<BPOSTParcel> getNotarrivedChina() {
        return notarrivedChina;
    }

    public void setNotarrivedChina(List<BPOSTParcel> notarrivedChina) {
        this.notarrivedChina = notarrivedChina;
    }

    List<BPOSTParcel> arrivedChina;
    List<BPOSTParcel> notarrivedChina;

}
