var H=Object.defineProperty,T=Object.defineProperties;var D=Object.getOwnPropertyDescriptors;var M=Object.getOwnPropertySymbols;var J=Object.prototype.hasOwnProperty,K=Object.prototype.propertyIsEnumerable;var I=(e,n,c)=>n in e?H(e,n,{enumerable:!0,configurable:!0,writable:!0,value:c}):e[n]=c,r=(e,n)=>{for(var c in n||(n={}))J.call(n,c)&&I(e,c,n[c]);if(M)for(var c of M(n))K.call(n,c)&&I(e,c,n[c]);return e},l=(e,n)=>T(e,D(n));import{j as G,a as Q,F as U,A as p,l as q,y as W,S as X}from"./vendor.js";const Y=function(){const n=document.createElement("link").relList;if(n&&n.supports&&n.supports("modulepreload"))return;for(const o of document.querySelectorAll('link[rel="modulepreload"]'))_(o);new MutationObserver(o=>{for(const t of o)if(t.type==="childList")for(const g of t.addedNodes)g.tagName==="LINK"&&g.rel==="modulepreload"&&_(g)}).observe(document,{childList:!0,subtree:!0});function c(o){const t={};return o.integrity&&(t.integrity=o.integrity),o.referrerpolicy&&(t.referrerPolicy=o.referrerpolicy),o.crossorigin==="use-credentials"?t.credentials="include":o.crossorigin==="anonymous"?t.credentials="omit":t.credentials="same-origin",t}function _(o){if(o.ep)return;o.ep=!0;const t=c(o);fetch(o.href,t)}};Y();var Z="/html/assets/radio-sr.png",ee="/html/assets/radio-lr.png";const ne="_container_k49dv_1",te="_container_show_k49dv_8",oe="_container_hide_k49dv_12",ae="_radio_k49dv_16",ce="_screen_k49dv_22",ie="_actions_k49dv_32",_e="_action_style_k49dv_36",se="_action_enable_k49dv_47 _action_style_k49dv_36",re="_action_validate_k49dv_55 _action_style_k49dv_36",le="_action_mix_k49dv_63 _action_style_k49dv_36",de="_action_close_k49dv_71",fe="_action_volume_up_k49dv_84 _action_style_k49dv_36",ye="_action_volume_down_k49dv_92 _action_style_k49dv_36",ve="_action_freq_primary_k49dv_101 _action_style_k49dv_36",ue="_action_freq_secondary_k49dv_109 _action_style_k49dv_36";var me={container:ne,container_show:te,container_hide:oe,radio:ae,screen:ce,actions:ie,action_style:_e,action_enable:se,action_validate:re,action_mix:le,action_close:de,action_volume_up:fe,action_volume_down:ye,action_freq_primary:ve,action_freq_secondary:ue};const he="_container_1jdag_1",ge="_container_show_1jdag_8",pe="_container_hide_1jdag_12",ke="_radio_1jdag_16",we="_screen_1jdag_22",qe="_actions_1jdag_38",$e="_action_style_1jdag_42",je="_action_enable_1jdag_53 _action_style_1jdag_42",Ce="_action_validate_1jdag_61 _action_style_1jdag_42",xe="_action_mix_1jdag_69 _action_style_1jdag_42",be="_action_close_1jdag_77",Le="_action_volume_up_1jdag_90 _action_style_1jdag_42",Ae="_action_volume_down_1jdag_98 _action_style_1jdag_42",Be="_action_freq_primary_1jdag_107 _action_style_1jdag_42",Re="_action_freq_secondary_1jdag_115 _action_style_1jdag_42";var Se={container:he,container_show:ge,container_hide:pe,radio:ke,screen:we,actions:qe,action_style:$e,action_enable:je,action_validate:Ce,action_mix:xe,action_close:be,action_volume_up:Le,action_volume_down:Ae,action_freq_primary:Be,action_freq_secondary:Re},w=(e=>(e[e.Left=0]="Left",e[e.Both=1]="Both",e[e.Right=2]="Right",e))(w||{});const Me="_screen_1cqr1_1",Ie="_enabled_1cqr1_19",Ne="_frequency_1cqr1_27",Oe="_meta_1cqr1_73";var j={screen:Me,enabled:Ie,frequency:Ne,meta:Oe};const a=G,k=Q,O=U,Pe=()=>a("svg",{xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 20 20",fill:"currentColor",children:a("path",{"fill-rule":"evenodd",d:"M9.383 3.076A1 1 0 0110 4v12a1 1 0 01-1.707.707L4.586 13H2a1 1 0 01-1-1V8a1 1 0 011-1h2.586l3.707-3.707a1 1 0 011.09-.217zM14.657 2.929a1 1 0 011.414 0A9.972 9.972 0 0119 10a9.972 9.972 0 01-2.929 7.071 1 1 0 01-1.414-1.414A7.971 7.971 0 0017 10c0-2.21-.894-4.208-2.343-5.657a1 1 0 010-1.414zm-2.829 2.828a1 1 0 011.415 0A5.983 5.983 0 0115 10a5.984 5.984 0 01-1.757 4.243 1 1 0 01-1.415-1.415A3.984 3.984 0 0013 10a3.983 3.983 0 00-1.172-2.828 1 1 0 010-1.415z","clip-rule":"evenodd"})}),ze=()=>a("svg",{xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 512 512",fill:"currentColor",children:a("path",{d:"M512 287.9l-.0042 112C511.1 444.1 476.1 480 432 480c-26.47 0-48-21.56-48-48.06V304.1C384 277.6 405.5 256 432 256c10.83 0 20.91 2.723 30.3 6.678C449.7 159.1 362.1 80.13 256 80.13S62.29 159.1 49.7 262.7C59.09 258.7 69.17 256 80 256C106.5 256 128 277.6 128 304.1v127.9C128 458.4 106.5 480 80 480c-44.11 0-79.1-35.88-79.1-80.06L0 288c0-141.2 114.8-256 256-256c140.9 0 255.6 114.5 255.1 255.3C511.1 287.5 511.1 287.7 512 287.9z"})}),Ve=({enabled:e,currentFrequency:n,primaryFrequency:c,setPrimaryFrequency:_,secondaryFrequency:o,setSecondaryFrequency:t})=>{const g=p(d=>{let y=n==="primary"?c.frequency:o.frequency;/^[0-9]{3}\.[0-9]{2}$/.test(d.target.value)&&(y=parseFloat(d.target.value)),n==="primary"?_(f=>l(r({},f),{frequency:y})):t(f=>l(r({},f),{frequency:y}))},[n,_,t]),u=d=>{switch(d){case w.Left:return"L";case w.Both:return"L/R";case w.Right:return"R"}};return a("div",{class:`${j.screen} ${e?j.enabled:""}`,children:e&&k(O,{children:[k("div",{className:j.frequency,children:[a("span",{children:n==="primary"?"F1":"F2"}),a("input",{type:"text",maxLength:6,value:(n==="primary"?c.frequency:o.frequency).toFixed(2),onChange:g})]}),k("span",{className:j.meta,children:[k("div",{children:[a(Pe,{}),n==="primary"?c.volume:o.volume,"%"]}),k("div",{children:[a(ze,{}),u(n==="primary"?c.ear:o.ear)]})]})]})})},Ee="https://soz-talk";function $(e,n={},c){e.charAt(0)!=="/"&&(e=`/${e}`),fetch(`${Ee}${e}`,{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(n)}).then(_=>{_.ok&&_.json().then(o=>{o==="ok"&&c()})}).catch(_=>console.error(_))}const Fe=e=>a("svg",l(r({},e),{xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 24 24",stroke:"currentColor","stroke-width":"2",children:a("path",{"stroke-linecap":"round","stroke-linejoin":"round",d:"M6 18L18 6M6 6l12 12"})})),N=e=>{const[n,c]=q(!1),[_,o]=q(!1),[t,g]=q("primary"),[u,d]=q({frequency:0,volume:100,ear:w.Both}),[y,f]=q({frequency:0,volume:100,ear:w.Both}),P=e.type==="radio"?Z:ee,s=e.type==="radio"?me:Se,z=p(()=>{$(`/${e.type}/enable`,{state:!_},()=>{o(i=>!i)})},[_,o]),A=p(i=>{g(i)},[g]),V=p(()=>{const i=t==="primary"?u.ear:y.ear;let h=w[i+1]!==void 0?i+1:0;$(`/${e.type}/change_ear`,{[t]:h},()=>{t==="primary"?d(m=>l(r({},m),{ear:h})):f(m=>l(r({},m),{ear:h}))})},[t,u,y,d,f]),B=p(i=>{i>=0&&i<=100&&$(`/${e.type}/change_volume`,{[t]:i},()=>{t==="primary"?d(h=>l(r({},h),{volume:i})):f(h=>l(r({},h),{volume:i}))})},[t,d,f]),E=p(()=>{const i=(t==="primary"?u.frequency:y.frequency)*100;i>=1e4&&i<=99999&&$(`/${e.type}/change_frequency`,{[t]:i},()=>{})},[t,u,y]),F=p(()=>{$(`/${e.type}/toggle`,{state:!1},()=>{c(!1)})},[c]),R=p(i=>{const{type:h,action:m,frequency:C,volume:x,ear:b,isPrimary:L,isEnabled:S}=i.data;h===e.type&&(m==="open"?c(!0):m==="close"?c(!1):m==="enabled"?S!==void 0&&o(S):m==="frequency_change"?C&&(L?d(v=>l(r({},v),{frequency:C/100})):f(v=>l(r({},v),{frequency:C/100}))):m==="volume_change"?x&&(L?d(v=>l(r({},v),{volume:x})):f(v=>l(r({},v),{volume:x}))):m==="ear_change"&&b&&(L?d(v=>l(r({},v),{ear:b})):f(v=>l(r({},v),{ear:b}))))},[]);return W(()=>(window.addEventListener("message",R),()=>{window.removeEventListener("message",R)}),[]),k("div",{class:`${s.container} ${n?s.container_show:s.container_hide}`,children:[a("img",{class:s.radio,src:P,alt:"Radio"}),a("div",{class:s.screen,children:a(Ve,{enabled:_,currentFrequency:t,primaryFrequency:u,setPrimaryFrequency:d,secondaryFrequency:y,setSecondaryFrequency:f})}),k("div",{class:s.actions,children:[a("div",{class:s.action_enable,onClick:z}),a("div",{class:s.action_validate,onClick:E}),a("div",{class:s.action_mix,onClick:V}),a(Fe,{class:s.action_close,onClick:F}),a("div",{class:s.action_volume_up,onClick:()=>B(t==="primary"?u.volume+10:y.volume+10)}),a("div",{class:s.action_volume_down,onClick:()=>B(t==="primary"?u.volume-10:y.volume-10)}),a("div",{class:s.action_freq_primary,onClick:()=>A("primary")}),a("div",{class:s.action_freq_secondary,onClick:()=>A("secondary")})]})]})},He=()=>k(O,{children:[a(N,{type:"radio"}),a(N,{type:"cibi"})]});X(a(He,{}),document.getElementById("app"));
