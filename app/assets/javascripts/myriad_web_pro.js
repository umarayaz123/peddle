/*===========================================================
 Typetester <http://www.typetester.org/>
 v.1.0, version date: 21 Aug 2011.
 Copyright (c) Marko Dugonjić, Creative Nights <http://www.creativenights.com/> 2005.
 This is beta. The code is occasionally ridiculous.
 Please, report troubles at <http://www.maratz.com/contact/>
 ============================================================*/
/**
 * SWFObject v1.5: Flash Player detection and embed - http://blog.deconcept.com/swfobject/
 *
 * SWFObject is (c) 2007 Geoff Stearns and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
if (typeof deconcept == "undefined") {
    var deconcept = new Object();
}
if (typeof deconcept.util == "undefined") {
    deconcept.util = new Object();
}
if (typeof deconcept.SWFObjectUtil == "undefined") {
    deconcept.SWFObjectUtil = new Object();
}
deconcept.SWFObject = function(_1, id, w, h, _5, c, _7, _8, _9, _a) {
    if (!document.getElementById) {
        return;
    }
    this.DETECT_KEY = _a ? _a : "detectflash";
    this.skipDetect = deconcept.util.getRequestParameter(this.DETECT_KEY);
    this.params = new Object();
    this.variables = new Object();
    this.attributes = new Array();
    if (_1) {
        this.setAttribute("swf", _1);
    }
    if (id) {
        this.setAttribute("id", id);
    }
    if (w) {
        this.setAttribute("width", w);
    }
    if (h) {
        this.setAttribute("height", h);
    }
    if (_5) {
        this.setAttribute("version", new deconcept.PlayerVersion(_5.toString().split(".")));
    }
    this.installedVer = deconcept.SWFObjectUtil.getPlayerVersion();
    if (!window.opera && document.all && this.installedVer.major > 7) {
        deconcept.SWFObject.doPrepUnload = true;
    }
    if (c) {
        this.addParam("bgcolor", c);
    }
    var q = _7 ? _7 : "high";
    this.addParam("quality", q);
    this.setAttribute("useExpressInstall", false);
    this.setAttribute("doExpressInstall", false);
    var _c = (_8) ? _8 : window.location;
    this.setAttribute("xiRedirectUrl", _c);
    this.setAttribute("redirectUrl", "");
    if (_9) {
        this.setAttribute("redirectUrl", _9);
    }
};
deconcept.SWFObject.prototype = {useExpressInstall:function(_d) {
    this.xiSWFPath = !_d ? "expressinstall.swf" : _d;
    this.setAttribute("useExpressInstall", true);
},setAttribute:function(_e, _f) {
    this.attributes[_e] = _f;
},getAttribute:function(_10) {
    return this.attributes[_10];
},addParam:function(_11, _12) {
    this.params[_11] = _12;
},getParams:function() {
    return this.params;
},addVariable:function(_13, _14) {
    this.variables[_13] = _14;
},getVariable:function(_15) {
    return this.variables[_15];
},getVariables:function() {
    return this.variables;
},getVariablePairs:function() {
    var _16 = new Array();
    var key;
    var _18 = this.getVariables();
    for (key in _18) {
        _16[_16.length] = key + "=" + _18[key];
    }
    return _16;
},getSWFHTML:function() {
    var _19 = "";
    if (navigator.plugins && navigator.mimeTypes && navigator.mimeTypes.length) {
        if (this.getAttribute("doExpressInstall")) {
            this.addVariable("MMplayerType", "PlugIn");
            this.setAttribute("swf", this.xiSWFPath);
        }
        _19 = "<embed type=\"application/x-shockwave-flash\" src=\"" + this.getAttribute("swf") + "\" width=\"" + this.getAttribute("width") + "\" height=\"" + this.getAttribute("height") + "\" style=\"" + this.getAttribute("style") + "\"";
        _19 += " id=\"" + this.getAttribute("id") + "\" name=\"" + this.getAttribute("id") + "\" ";
        var _1a = this.getParams();
        for (var key in _1a) {
            _19 += [key] + "=\"" + _1a[key] + "\" ";
        }
        var _1c = this.getVariablePairs().join("&");
        if (_1c.length > 0) {
            _19 += "flashvars=\"" + _1c + "\"";
        }
        _19 += "/>";
    } else {
        if (this.getAttribute("doExpressInstall")) {
            this.addVariable("MMplayerType", "ActiveX");
            this.setAttribute("swf", this.xiSWFPath);
        }
        _19 = "<object id=\"" + this.getAttribute("id") + "\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"" + this.getAttribute("width") + "\" height=\"" + this.getAttribute("height") + "\" style=\"" + this.getAttribute("style") + "\">";
        _19 += "<param name=\"movie\" value=\"" + this.getAttribute("swf") + "\" />";
        var _1d = this.getParams();
        for (var key in _1d) {
            _19 += "<param name=\"" + key + "\" value=\"" + _1d[key] + "\" />";
        }
        var _1f = this.getVariablePairs().join("&");
        if (_1f.length > 0) {
            _19 += "<param name=\"flashvars\" value=\"" + _1f + "\" />";
        }
        _19 += "</object>";
    }
    return _19;
},write:function(_20) {
    if (this.getAttribute("useExpressInstall")) {
        var _21 = new deconcept.PlayerVersion([6,0,65]);
        if (this.installedVer.versionIsValid(_21) && !this.installedVer.versionIsValid(this.getAttribute("version"))) {
            this.setAttribute("doExpressInstall", true);
            this.addVariable("MMredirectURL", escape(this.getAttribute("xiRedirectUrl")));
            document.title = document.title.slice(0, 47) + " - Flash Player Installation";
            this.addVariable("MMdoctitle", document.title);
        }
    }
    if (this.skipDetect || this.getAttribute("doExpressInstall") || this.installedVer.versionIsValid(this.getAttribute("version"))) {
        var n = (typeof _20 == "string") ? document.getElementById(_20) : _20;
        n.innerHTML = this.getSWFHTML();
        return true;
    } else {
        if (this.getAttribute("redirectUrl") != "") {
            document.location.replace(this.getAttribute("redirectUrl"));
        }
    }
    return false;
}};
deconcept.SWFObjectUtil.getPlayerVersion = function() {
    var _23 = new deconcept.PlayerVersion([0,0,0]);
    if (navigator.plugins && navigator.mimeTypes.length) {
        var x = navigator.plugins["Shockwave Flash"];
        if (x && x.description) {
            _23 = new deconcept.PlayerVersion(x.description.replace(/([a-zA-Z]|\s)+/, "").replace(/(\s+r|\s+b[0-9]+)/, ".").split("."));
        }
    } else {
        if (navigator.userAgent && navigator.userAgent.indexOf("Windows CE") >= 0) {
            var axo = 1;
            var _26 = 3;
            while (axo) {
                try {
                    _26++;
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash." + _26);
                    _23 = new deconcept.PlayerVersion([_26,0,0]);
                } catch(e) {
                    axo = null;
                }
            }
        } else {
            try {
                var axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
            } catch(e) {
                try {
                    var axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
                    _23 = new deconcept.PlayerVersion([6,0,21]);
                    axo.AllowScriptAccess = "always";
                } catch(e) {
                    if (_23.major == 6) {
                        return _23;
                    }
                }
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
                } catch(e) {
                }
            }
            if (axo != null) {
                _23 = new deconcept.PlayerVersion(axo.GetVariable("$version").split(" ")[1].split(","));
            }
        }
    }
    return _23;
};
deconcept.PlayerVersion = function(_29) {
    this.major = _29[0] != null ? parseInt(_29[0]) : 0;
    this.minor = _29[1] != null ? parseInt(_29[1]) : 0;
    this.rev = _29[2] != null ? parseInt(_29[2]) : 0;
};
deconcept.PlayerVersion.prototype.versionIsValid = function(fv) {
    if (this.major < fv.major) {
        return false;
    }
    if (this.major > fv.major) {
        return true;
    }
    if (this.minor < fv.minor) {
        return false;
    }
    if (this.minor > fv.minor) {
        return true;
    }
    if (this.rev < fv.rev) {
        return false;
    }
    return true;
};
deconcept.util = {getRequestParameter:function(_2b) {
    var q = document.location.search || document.location.hash;
    if (_2b == null) {
        return q;
    }
    if (q) {
        var _2d = q.substring(1).split("&");
        for (var i = 0; i < _2d.length; i++) {
            if (_2d[i].substring(0, _2d[i].indexOf("=")) == _2b) {
                return _2d[i].substring((_2d[i].indexOf("=") + 1));
            }
        }
    }
    return "";
}};
deconcept.SWFObjectUtil.cleanupSWFs = function() {
    var _2f = document.getElementsByTagName("OBJECT");
    for (var i = _2f.length - 1; i >= 0; i--) {
        _2f[i].style.display = "none";
        for (var x in _2f[i]) {
            if (typeof _2f[i][x] == "function") {
                _2f[i][x] = function() {
                };
            }
        }
    }
};
if (deconcept.SWFObject.doPrepUnload) {
    if (!deconcept.unloadSet) {
        deconcept.SWFObjectUtil.prepUnload = function() {
            __flash_unloadHandler = function() {
            };
            __flash_savedUnloadHandler = function() {
            };
            window.attachEvent("onunload", deconcept.SWFObjectUtil.cleanupSWFs);
        };
        window.attachEvent("onbeforeunload", deconcept.SWFObjectUtil.prepUnload);
        deconcept.unloadSet = true;
    }
}
if (!document.getElementById && document.all) {
    document.getElementById = function(id) {
        return document.all[id];
    };
}
var getQueryParamValue = deconcept.util.getRequestParameter;
var FlashObject = deconcept.SWFObject;
var SWFObject = deconcept.SWFObject;
/* Global vars */
var d = document;
var w = window;
var browser = navigator.userAgent.toLowerCase();
var delay = false;
var maxDelay = 5;
var cntrlThr = false;
var cntrlSrc = 0;
var cookies = true;
var opera = (w.opera && d.createTextNode) ? true : false;
var IE = (d.all && !w.opera && browser.indexOf('mac') == -1) ? true : false;
var safari = (browser.indexOf('safari') != -1) ? true : false;
var httpReq = getXMLHttpRequest();
var XMLHttpSupported = httpReq ? true : false;
var $ = new Function('x', 'return d.getElementById(x)');
var $$ = new Function('x', 'y', 'return x.getElementsByTagName(y)');
var nE = new Function('x', 'return d.createElement(x)');
var textNode = new Function('x', 'return d.createTextNode(x)');
var docFrag = new Function('return d.createDocumentFragment()');
var hex = new Function('x', 'return (x).toString(16)');
var baseFontSize = new Function("$('preview').style.fontSize = $('bfs').value");
var inlineStyle = new Function('x', 'v', "IE ? x.style.setAttribute('cssText',v) : x.setAttribute('style',v)");
/* make valSet string pretty */
function valSet2cookie(v) {
    return v.replace(/;/gi, '|');
}
;
function valSet2query(v) {
    return v.replace(/;/gi, '&').replace(/:/gi, '=');
}
;
function cookie2srcVals(c) {
    c = c.replace(RegExp('^font\-family:', 'gi'), '');
    return c.replace(/\|/gi, ';');
}
;
function fixFontFamily(v) {
    v = v.replace(RegExp('font-family:font-family:', 'gi'), 'font-family:');
    v = v.replace(RegExp('font\-family:;', 'gi'), '');
    return v.replace(RegExp('family:(.[^;]*)?;', 'gi'), 'family:"$1";');
}
;
function fixSecondFamilyRule(v) {
    if (v.indexOf(';font-family:;') == -1) {
        v = v.replace(RegExp('family:(.*);font\-family:(.{2,});font\-size', 'gi'), 'family:$2;font-size');
        v = v.replace(RegExp('family:(.*);font\-family:;', 'gi'), 'family:$1;');
    } else {
        v = v.replace('font-family:;', '');
    }
    return v;
}
;
/* add event by zytzagoo <http://www.mi3dot.org/> */
function aE(oTarget, sType, fpDest) {
    var oOldEvent = oTarget[sType];
    if (typeof(oOldEvent) != 'function') {
        oTarget[sType] = fpDest;
    } else {
        oTarget[sType] = function(e) {
            oOldEvent(e);
            fpDest(e);
        };
    }
    ;
}
;
/* check and create XMLHttpRequest object */
function getXMLHttpRequest() {
    var i,
        r = null;
    if (w.XMLHttpRequest) {
        r = new XMLHttpRequest();
    } else if (w.ActiveXObject) {
        var m = new Array('Msxml2.XMLHTTP', 'Microsoft.XMLHTTP');
        i = m.length;
        while (i--) {
            try {
                r = new ActiveXObject(m[i]);
            } catch (e) {
            }
            ;
        }
        ;
    }
    ;
    return r;
}
;
var queryStats = function(q) {
    var u = '/stats/';
    if (typeof(httpReq.setRequestHeader) != 'undefined') {
        httpReq.open('POST', u, true);
        httpReq.setRequestHeader('Method', 'POST' + u + 'HTTP/1.1');
        httpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        httpReq.setRequestHeader('Content-Length', q.length);
        httpReq.setRequestHeader('Connection', 'close');
        httpReq.send(q);
    } else {
        q = encodeURI(q);
        q = q.replace(/#/gi, '%23');
        httpReq.open('GET', u + '?' + q, true);
        httpReq.send(null);
    }
    ;
};
function updateStats(v) {
    if (typeof(v) != 'string' || httpReq == null) return;
    if (httpReq.readyState > 0 && httpReq.readyState < 4) httpReq.abort();
    var q = valSet2query(v);
    queryStats(q);
}
;
var addTxt = function(t) {
    t = t.replace(/\n/gi, '<br />');
    t = t.replace(/\&/gi, '&#38;');
    var p, ps = $$($('preview'), 'p'), oldTxt, newTxt,
        i = ps.length;
    while (i--) {
        p = ps[i];
        newTxt = t;
        oldTxt = p.firstChild ? p.firstChild : '';
        p.innerHTML = newTxt;
    }
    ;
    createCookie('textArea', encodeURI(t), 365);
};
var appendStyles = function(t, v) {
    var td, tds = $$($('preview'), 'td'),
        i = tds.length;
    while (i--) {
        td = tds[i];
        if (td.className == 'pt' + t) {
            inlineStyle(td, v);
        }
        ;
    }
    ;
};
var updateCSSLinks = function(t, v) {
    var q, h,
        allLinks = $$(d, 'a'),
        i = allLinks.length;
    while (i--) {
        var cLink = allLinks[i];
        if (cLink.className == 'get_css_link' && cLink.firstChild.nodeValue.charAt(0) == t) {
            q = '?si=' + t + '&rules=' + encodeURI(v.replace(/;/gi, ';' + "\n").replace(/:/gi, ': ')).replace(/#/gi, '%23');
            h = cLink.href;
            cLink.href = (!h.search) ? h + q : h.split('?')[0] + q;
        }
        ;
    }
    ;
};
var populateLocalFonts = function(fs) {
    var f, opt, slct, slctFrag, inpt, inptClass;
    if (typeof(fs) == 'string') {
        fs = fs.split(',');
        fs.unshift('');
        fs.reverse();
    }
    ;
    var i = 4;
    while (--i) {
        inpt = $('st' + i);
        inptClass = inpt.className.replace(RegExp('inp_([A-Za-z\-]*)?\s?(.*)?', 'i'), 'inp_$1');
        slct = nE('select');
        slct.id = 'st' + i;
        slct.name = slct.id;
        slct.className = inptClass;
        slct.setAttribute('title', 'Specify typeface from your system.');
        aE(slct, 'onfocus', formSwitch);
        aE(slct, 'onchange', applyTo);
        slctFrag = docFrag();
        var j = fs.length;
        while (j--) {
            f = fs[j];
            opt = nE('option');
            opt.setAttribute('value', f);
            optText = textNode(f);
            opt.appendChild(optText);
            slctFrag.appendChild(opt);
        }
        ;
        slct.appendChild(slctFrag);
        inpt.parentNode.replaceChild(slct, inpt);
    }
    ;
};
/* get client's fonts by Pepa <http://www.unpljugged.com/> */
function getFontList(user_fonts) {
    var fs = null,
        obj = $('font_catcher');
    if (typeof(obj.GetVariable) != 'undefined') {
        fs = obj.GetVariable('/:user_fonts');
    } else if (typeof(user_fonts) != 'undefined') {
        fs = unescape(user_fonts);
    }
    ;
    if (fs) {
        populateLocalFonts(fs);
    }
    ;
}
;
/* Cookie create function by Scott Andrew <http://www.scottandrew.com/> */
function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = '; expires=' + date.toGMTString();
    } else var expires = '';
    d.cookie = name + '=' + value + expires + '; path=/';
}
;
function readCookie(name) {
    var nameEQ = name + '=',
        ca = d.cookie.split(';'),
        c;
    for (var i = 0; i < ca.length; i++) {
        c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    ;
    return null;
}
;
function resetCookies() {
    if (!confirm('This will reset your current setups. Are you sure?')) return false;
    var i = 4;
    while (i--) {
        createCookie('settings' + i, '', -1);
    }
    ;
    createCookie('textArea', '', -1);
    return true;
}
;
/* countdown (delay for stats update) */
function delayCounter(v, currCntrl, copied) {
    if (currCntrl < cntrlThr) return;
    if (typeof(copied) == 'undefined') copied = false;
    if (delay > 0 && delay < (maxDelay + 1)) {
        cntr = setTimeout("delayCounter('" + v + "','" + currCntrl + "'," + copied + ")", 1000);
        delay--;
    } else if (delay == 0) {
        if (XMLHttpSupported && !copied) updateStats(v);
        return false;
    }
    ;
}
;
/* populate target form */
function populateTargetForm(trgtElems, srcVals) {
    var i = trgtElems.length,
        j, opts;
    while (i--) {
        var trgtElem = trgtElems[i];
        if (trgtElem.nodeName.toLowerCase() == 'select') {
            opts = $$(trgtElem, 'option');
            j = opts.length;
            while (j--) {
                opts[j].selected = opts[j].value == srcVals[i] ? true : false;
            }
            ;
        } else {
            trgtElem.value = (trgtElem.type == 'checkbox') ? trgtElem.id.replace(RegExp('([A-Za-z\-]*)?([0-9])?', 'i'), '$1') : srcVals[i];
            if (trgtElem.type == 'checkbox') {
                trgtElem.checked = (srcVals[i] == 'normal') ? false : true;
            }
            ;
        }
        ;
    }
    ;
}
;
/* switch between forms */
function formSwitch() {
    if (typeof(srcID) != 'string' || typeof(srcID) == 'undefined') srcID = this.id.toString();
    srcID = srcID.charAt(srcID.length - 1);
    if (cntrlSrc > 0 && cntrlSrc < 4 && cntrlSrc != srcID) {
        applyTo(cntrlSrc, cntrlSrc, 'switch');
    }
    ;
// set global srcTarget
    cntrlSrc = srcID;
}
;
/* pick up form elements and corresponding class names */
function getFormElements(c) {
    var child,
        fieldset,
        fieldsetChildren,
        fieldsetChild,
        tds,
        td,
        tdChildren,
        tdChild,
        totalElements = new Array(),
        classNames = new Array(),
        regxp = new RegExp('inp_([A-Za-z\-]*)?\s?(.*)?', 'i');
    if (typeof(c) == 'undefined') var c = '1';
    var fieldsets = $$($('typecol' + c), 'fieldset');
    var tE_cnt = 0,
        i = fieldsets.length,
        j, k, l;
    while (i--) {
        fieldset = fieldsets[i];
        fieldsetChildren = fieldset.childNodes;
        j = fieldsetChildren.length;
        while (j--) {
            fieldsetChild = fieldsetChildren[j];
            child = fieldsetChild.nodeName.toLowerCase();
            switch (child) {
                case 'select':
                case 'input':
                    totalElements[tE_cnt] = fieldsetChild;
                    classNames[tE_cnt] = fieldsetChild.className.replace(regxp, '$1');
                    tE_cnt++;
                    break;
                case 'table':
                    tds = $$(fieldsetChild, 'td');
                    k = tds.length;
                    while (k--) {
                        td = tds[k];
                        tdChildren = td.childNodes;
                        l = tdChildren.length;
                        while (l--) {
                            tdChild = tdChildren[l];
                            child = tdChild.nodeName.toLowerCase();
                            switch (child) {
                                case 'select':
                                case 'input':
                                    totalElements[tE_cnt] = tdChild;
                                    classNames[tE_cnt] = tdChild.className.replace(regxp, '$1');
                                    tE_cnt++;
                            }
                            ;
                        }
                        ;
                    }
                    ;
                    break;
            }
            ;
        }
        ;
        totalElements.reverse();
        classNames.reverse();
    }
    ;
    return new Array(totalElements, classNames);
}
;
/* source -><- target crossroad */
function applyTo(srcID, trgtID, relation, srcVals) {
    var i,j,
        switched = false,
        copied = false,
        v = new Array();
    switch (relation) {
        case 'switch':
            switched = true;
            break;
        case 'copy':
            copied = true;
            break;
    }
    ;
    if (typeof(srcVals) == 'undefined') srcVals = false;
    /* if srcID isn't directly passed, pull it from 'this' */
    if ((typeof(srcID) != 'string' || typeof(srcID) == 'undefined') && !srcVals) {
        srcID = this.id.toString();
        /* here we keep the original srcID of the SELECT element */
        var origID = srcID;
    }
    ;
    /* Safari breaks here, that's why the following */
    if (srcID.length > 1) srcID = srcID.charAt(srcID.length - 1);
    trgtID = (typeof(trgtID) != 'string') ? srcID : trgtID.charAt(trgtID.length - 1);
    var propertiesSet = getFormElements()[1];
    /* if the srcValues haven't been passed: */
    if (!srcVals) {
        var srcElements = getFormElements(srcID)[0];
        var srcVals = new Array();
        var srcElem,
            eNN,
            forceValue,
            opts;
        for (i = 0; i < srcElements.length; i++) {
            srcElem = srcElements[i];
            eNN = srcElem.nodeName.toLowerCase();
            /* shameless value hijack: */
            forceValue = (srcElem.id.indexOf('st') != -1 && origID && origID.indexOf('fl') != -1) ? true : false;
            switch (eNN) {
                case 'select':
                    opts = $$(srcElem, 'option');
                    for (j = 0; j < opts.length; j = j + 1) {
                        if (opts[j].selected == true) {
                            srcVals[i] = (forceValue) ? srcVals[i - 1] : opts[j].value;
                        }
                        ;
                    }
                    ;
                    break;
                case 'input':
                    if (srcElem.type == 'checkbox') {
                        srcVals[i] = (srcElem.checked) ? srcElem.value : 'normal';
                    } else {
                        srcVals[i] = (forceValue) ? srcVals[i - 1] : srcElem.value;
                    }
                    ;
                    break;
            }
            ;
        }
        ;
    }
    ;
    /* collecting and creating CSS rules set */
    i = propertiesSet.length;
    while (i--) {
        v[i] = propertiesSet[i] + ':' + srcVals[i];
    }
    ;
    v = v.join(';');
    v = v.replace(RegExp('undefined', 'i'), '');
    /* update CSS POPUP links + remove extra font-family */
    updateCSSLinks(trgtID, fixSecondFamilyRule(v));
    /* populate target form */
    populateTargetForm(getFormElements(trgtID)[0], srcVals);
    /* append styles to PREVIEW PANE */
    appendStyles(trgtID, fixFontFamily(v));
    /* set up delay for STATS */
    delay = (copied || switched) ? 0 : maxDelay;
    cntrlThr = cntrlThr + 1;
    delayCounter(fixSecondFamilyRule(v), cntrlThr, copied);
    /* update COOKIES: */
    updateCookies = setTimeout("createCookie('settings" + trgtID + "', valSet2cookie('" + v + "'), 365)", 100);
    return false;
}
;
/* main nav switcher */
function contentSwitch() {
    /* remove annoying rectangle in mozilla browsers: */
    this.blur();
    var thisHref = this.href;
    if (thisHref.indexOf('#') == -1) return;
    var prnt = this.parentNode;
    var lis = $$($('main_nav'), 'li');
    var i = lis.length;
    while (i--) {
        lis[i].className = '';
    }
    ;
    prnt.className = 'active';
    var hrArr = thisHref.split('/');
    var targetBlock = $(hrArr.pop().replace(/#/, ''));
    var siblings = $$(targetBlock.parentNode, 'div');
    i = siblings.length;
    while (i--) {
        if (siblings[i].className.indexOf('support_content') != -1) {
            siblings[i].className = 'support_content';
        }
        ;
    }
    ;
    targetBlock.className = 'support_content active';
    return false;
}
;
/* restore settings from previous visit */
function restoreSettings() {
    if ($('st3').nodeName.toLowerCase() == 'select') {
        if (cookies) {
            var i = 4,
                j;
            while (i--) {
                if (readCookie('settings' + i)) {
                    var srcElems = getFormElements(i)[0];
                    var srcVals = cookie2srcVals(readCookie('settings' + i)).split(';');
                    j = srcVals.length;
                    while (j--) {
                        srcVals[j] = srcVals[j].split(':')[1];
                    }
                    ;
                    if (srcVals.length < 10) {
                        srcVals.unshift(srcVals[srcElems.length - 1]);
                    }
                    ;
                    applyTo(i, i, 'copy', srcVals);
                }
                ;
            }
            ;
            if (readCookie('textArea')) {
                var txtArea = $$(d, 'textarea')[0];
                var t = decodeURI(readCookie('textArea'));
                if (opera) {
                    txtArea.value = t.replace(/<br \/>/gi, '\n');
                } else {
                    txtArea.replaceChild(textNode(t.replace(/<br \/>/gi, '\n')), txtArea.firstChild);
                }
                ;
                addTxt(t);
            }
            ;
        }
        ;
    } else {
        restoreTimeout = setTimeout("restoreSettings();", 50);
    }
    ;
}
;
var styleInHead = function() {
    var h = $$(d, 'head')[0],
        s = nE('style');
    s.setAttribute('type', 'text/css');
    s.setAttribute('media', 'all');
    h.appendChild(s);
};
/* attaching events to elements */
function fixHooks() {
    var i,j;
    if (w.top != w.self) w.top.location = 'http://typetester.maratz.com/';
    /* get fonts from the client's machine and replace INPUT with SELECT */
    if (IE) getFontList();
    /* since JavaScript is enabled, make BODY visible */
    var bdy = $$(d, 'body')[0];
    bdy.className = 'visible';
    /* collections */
    var txtArea = $$(d, 'textarea')[0];
    var slcts = $$(d, 'select');
    var inpts = $$(d, 'input');
    var lbls = $$(d, 'label');
    var frms = $$(d, 'form');
    var navLinks = $$($('main_nav'), 'a');
    var allLinks = $$(d, 'a');
    var tds = $$($('preview'), 'td');
    /* attach events on FORMS */
    i = frms.length;
    while (i--) {
        aE(frms[i], 'onsubmit', function() {
            return false;
        });
    }
    ;
    /* attach events on TEXTAREA */
    aE(txtArea, 'onkeyup', function() {
        addTxt(this.value);
    });
    aE(txtArea, 'onclick', function() {
        addTxt(this.value);
    });
    /* attach events on COPY BUTTONS */
    i = lbls.length;
    while (i--) {
        var lbl = lbls[i];
        if (lbl.className == 'applysettings') {
            var btns = $$(lbl, 'a');
            j = btns.length;
            while (j--) {
                aE(btns[j], 'onclick', function() {
                    applyTo(this.parentNode.id, this.getAttribute('rel'), 'copy');
                    return false;
                });
            }
            ;
        }
        ;
    }
    ;
    /* attach events on SELECTS */
    i = slcts.length;
    while (i--) {
        var sel = slcts[i];
        if (sel.id == 'bfs') {
            aE(sel, 'onfocus', baseFontSize);
            aE(sel, 'onchange', baseFontSize);
        } else {
            if (sel.id.indexOf('st') != -1) continue;
            aE(sel, 'onfocus', formSwitch);
            aE(sel, 'onchange', applyTo);
        }
        ;
    }
    ;
    /* attach events on INPUTS */
    var cpImg, btn, inp;
    i = inpts.length;
    while (i--) {
        inp = inpts[i];
        aE(inp, 'onfocus', formSwitch);
        aE(inp, 'onkeyup', applyTo);
        if (inp.type == 'checkbox') {
            aE(inp, 'onchange', applyTo);
            continue;
        }
        ;
        /* since it's already in the loop, set up color pickers */
        if (inp.className.indexOf('color') != -1) {
            /* colorpicker image: */
            cpImg = $('colorpicker-' + inp.id);
            aE(cpImg, 'onmousemove', getColor);
            aE(cpImg, 'onclick', function(e) {
                getColor(e, this.id, 'on');
            });
            aE(cpImg, 'onmouseout', function(e) {
                getColor(e, this.id, 'off');
            });
            aE(inp, 'onchange', applyTo);
            /* color picker button */
            btn = $('applyto' + inp.id);
            aE(btn, 'onclick', function() {
                this.blur();
                showColorPicker('colorpicker-' + this.id.replace(RegExp('applyto', ''), ''));
                return false;
            });
        }
        ;
    }
    ;
    /* attach events on MAIN NAV items */
    i = navLinks.length;
    while (i--) {
        aE(navLinks[i], 'onclick', contentSwitch);
    }
    ;
    /* attach events on RESET SETTINGS */
    aE($('reset_settings'), 'onclick', resetCookies);
    /* call settings restoration: */
    restoreSettings();
    /* set base preview panel font size */
    baseFontSize();
    /* CSS popup */
    i = allLinks.length;
    while (i--) {
        var cLink = allLinks[i];
        if (cLink.className == 'stats_link') {
            aE(cLink, 'onclick', function() {
                var statsw = w.open(this.href, 'TypetesterStats', 'width=950,height=600,scrollbars=yes,resizable=yes');
                if (w.focus) statsw.focus();
                return false;
            });
        }
        ;
        if (cLink.className == 'get_css_link') {
            aE(cLink, 'onclick', function() {
                var cssw = w.open(this.href, 'CSS', 'width=400,height=430,top=100,left=500,scrollbars=yes,resizable=yes');
                if (w.focus) cssw.focus();
                return false;
            });
        }
        ;
    }
    ;
}
;
/* show/hide color picker */
function showColorPicker(s) {
    var picker = $(s);
    picker.style.display = (picker.style.display == 'block') ? 'none' : 'block';
}
;
/* some color picker functions by Horde <http://www.horde.org/> */
function getColor(e, srcID, ap) {
    if (typeof(srcID) == 'undefined') var srcID = this.id;
    if (typeof(e) == 'undefined') var e = w.event;
    /* fix elements involved: */
    var img = $(srcID),
        inpID = srcID.replace(RegExp('colorpicker-', ''), ''),
        inp = $(inpID);
    var prop,
        icn = inp.className,
        color,
        tds = $$($('preview'), 'td'),
        td,
        colNo = srcID.charAt(srcID.length - 1);
    if (icn.indexOf('inp_color') != -1) {
        prop = 'color';
    } else if (icn.indexOf('inp_background-color') != -1) {
        prop = 'backgroundColor';
    }
    ;
    var yTemp = safari ? 0 : getCurrentPosition()[1],
        xTemp = safari ? 0 : getCurrentPosition()[0];
    var x = e.clientX - (findPos(img)[1] - yTemp),
        y = e.clientY - (findPos(img)[0] - xTemp);
    var rmax = 0,
        gmax = 0,
        bmax = 0;
    if (y <= 32) {
        rmax = 255;
        gmax = (y / 32.0) * 255;
        bmax = 0;
    } else if (y <= 64) {
        y = y - 32;
        rmax = 255 - (y / 32.0) * 255;
        gmax = 255;
        bmax = 0;
    } else if (y <= 96) {
        y = y - 64;
        rmax = 0;
        gmax = 255;
        bmax = (y / 32.0) * 255;
    } else if (y <= 128) {
        y = y - 96;
        rmax = 0;
        gmax = 255 - (y / 32.0) * 255;
        bmax = 255;
    } else if (y <= 160) {
        y = y - 128;
        rmax = (y / 32.0) * 255;
        gmax = 0;
        bmax = 255;
    } else {
        y = y - 160;
        rmax = 255;
        gmax = 0;
        bmax = 255 - (y / 32.0) * 255;
    }
    ;
    var r,g,b;
    if (x <= 50) {
        r = Math.abs(Math.floor(rmax * x / 50.0));
        g = Math.abs(Math.floor(gmax * x / 50.0));
        b = Math.abs(Math.floor(bmax * x / 50.0));
    } else {
        x -= 50;
        r = Math.abs(Math.floor(rmax + (x / 50.0) * (255 - rmax)));
        g = Math.abs(Math.floor(gmax + (x / 50.0) * (255 - gmax)));
        b = Math.abs(Math.floor(bmax + (x / 50.0) * (255 - bmax)));
    }
    ;
    color = rgb2hex(r, g, b);
    if (ap == 'on') {
        inp.value = color;
        img.style.display = 'none';
        applyTo(srcID);
    } else {
        if (ap == 'off') color = inp.value;
    }
    ;
    var i = tds.length;
    while (i--) {
        td = tds[i];
        if (td.className == 'pt' + colNo) {
            td.style[prop] = color;
        }
        ;
    }
    ;
    return false;
}
;
function rgb2hex(r, g, b) {
    color = '#';
    color += hex(Math.floor(r / 16));
    color += hex(r % 16);
    color += hex(Math.floor(g / 16));
    color += hex(g % 16);
    color += hex(Math.floor(b / 16));
    color += hex(b % 16);
    return color;
}
;
/* Find position function by PPK <http://www.quirksmode.org/> */
function findPos(obj) {
    var cl = 0,
        ct = 0;
    if (obj.offsetParent) {
        while (obj.offsetParent) {
            cl += obj.offsetLeft;
            ct += obj.offsetTop;
            obj = obj.offsetParent;
        }
        ;
    } else if (obj.x) {
        cl += obj.x;
        ct += obj.y;
    }
    ;
    return new Array(ct, cl);
}
;
function getCurrentPosition() {
    var x = 0,
        y = 0;
    if (d.body && d.body.scrollTop) {
        x = d.body.scrollTop;
        y = d.body.scrollLeft;
    } else if (d.documentElement && d.documentElement.scrollTop) {
        x = d.documentElement.scrollTop;
        y = d.documentElement.scrollLeft;
    } else if (w.pageYOffset) {
        x = w.pageYOffset;
        y = w.pageXOffset;
    }
    ;
    return new Array(x, y);
}
;
<!--Refer failed to connect to mysql-->/* time: 0.014216899871826 */