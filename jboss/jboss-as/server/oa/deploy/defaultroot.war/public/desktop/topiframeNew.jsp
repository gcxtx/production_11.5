<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="com.whir.ezoffice.remind.RemindInfo"%>
<%@ page import="com.whir.ezoffice.workmanager.event.po.EventPO"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.whir.ezoffice.remind.bd.RemindBD"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
    String usedPortal = request.getParameter("usedPortal");

	//-----判断该账号在其他机器上是否有登录，如果有登录，将本客户端踢出---2009-05-19----start
	com.whir.org.bd.usermanager.UserBD userBD = new com.whir.org.bd.usermanager.UserBD();
	String returnStr = userBD.kickoutUser(request);
	//-----判断该账号在其他机器上是否有登录，如果有登录，将本客户端踢出---2009-05-19----end
	if(returnStr.equals("yes")){//另一客户端用同一帐号登录了
%>
		<script>
        <%if("1".equals(usedPortal)){%>
            parent.parent.window.location.href="<%=rootPath%>/portal.jsp?errorType=kickout";
        <%}else{%>
			parent.parent.window.location.href="<%=rootPath%>/login.jsp?errorType=kickout";
        <%}%>
		</script>
<%
	}
	if(session==null || session.getAttribute("userId")==null){
%>
		<script>
        <%if("1".equals(usedPortal)){%>
            parent.parent.window.location.href="<%=rootPath%>/portal.jsp?errorType=overtime";
        <%}else{%>
			parent.parent.window.location.href="<%=rootPath%>/login.jsp?errorType=overtime";
        <%}%>
		</script>
<%
	}else{
        String _skin = session.getAttribute("skin").toString();
		String domainId = session.getAttribute("domainId")==null?"0":session.getAttribute("domainId").toString();
		String userId   = session.getAttribute("userId").toString();
		String userAccount = session.getAttribute("userAccount").toString();
		//外部邮件--exchange
 		String mailRemindType = com.whir.component.SysSettings.getInstance(domainId).getMailRemindType();
		String exchangeMailNum = "";
		if(mailRemindType!=null && mailRemindType.equals("1")){
			exchangeMailNum = new com.whir.integration.exchange.ExchangeService().unReadCount(userAccount);
		}
		
		RemindInfo remindInfo = RemindInfo.getInstance(domainId, userId);
		Map map = remindInfo.getRemindInfo(userId);

		//删除在security_onlineuser表中已经超过24小时的在线人员数据记录--2009-04-30--start
		//com.whir.org.bd.usermanager.UserBD userBD = new com.whir.org.bd.usermanager.UserBD();
		//int outHour = 24;//超过多少小时的在线用户数据记录删除
		//String returnStr = userBD.delNoOnlineUser(request,outHour);
		//删除在security_onlineuser表中已经超过24小时的在线人员数据记录--2009-04-30--end

		int userNum = new com.whir.ezoffice.remind.bd.RemindBD().getOnlineUserNum(domainId).intValue();

		int newMail=0;
		int newTask=0;
		int checkTask=0;
		int waitTask=0;
		int newReport=0;
		int newEvent=0;
		int waitFile=0;
		int waitRead=0;
		int matureFile=0;
		int outMail=0;
		int press=0;
		int newMessage=0;
		int newFeedBack=0;
		int newInnerSendFile=0;
		int mustReadInfoCount=0;
		int meeting=0;
		int remindContract=0;
		int weekReport=0;
		int monthReport=0;

		List remindList = new ArrayList();

		String soundFile="";
		String soundType="";
		boolean sound=false;

		/***********************取foxmail的新邮件数****************************/
		//String mailURL="";
		//String userAccount=session.getAttribute("userAccount").toString();
		//String userPassword=session.getAttribute("userPassword").toString();
		//com.whir.webmail.foxmail.FoxMailTools fmtools=new com.whir.webmail.foxmail.FoxMailTools();
		//newMail=fmtools.getNewMailNum(userAccount,userPassword,"","");
		//mailURL = fmtools.getMailURL();
		/***********************取foxmail的新邮件数****************************/

		String orgId = session.getAttribute("orgId")+"";
		String orgIdString = session.getAttribute("orgIdString")+"";
		RemindBD remindBD = new RemindBD();
		Map remindMap = remindBD.getRemindModule(userId, orgId, orgIdString);
		String m_ReceiveFileBoxCount = (String)remindMap.get("ReceiveFileBoxCount");
%>
<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <meta http-equiv="refresh" content="30">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <head>
	<script type="text/javascript">
		var whirRootPath = "<%=rootPath%>";
		var preUrl = "<%=preUrl%>"; 
	</script>
	<script src="<%=rootPath%>/scripts/jquery-1.11.2.min.js" type="text/javascript"></script>
    </head>
    <body leftmargin="0" topmargin="0" onload="initRemindInfo();">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr valign="top">
                <td height="26">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="280"  height="26">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
			<!--------------------------------增加一iframe 不断刷新邮件服务器保持session------------->
			<!-- <tr style="display:none">
			  <td>
			     <iframe src="<%//=mailURL%>/heart.asp"></iframe>
			  </td>
			</tr> -->
			<!--------------------------------增加一iframe 不断刷新邮件服务器保持session------------->
        </table>
    </body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--
<%String userNumStr = userNum + "";%>

<%if(whir_skin.indexOf("2013")>-1||whir_skin.indexOf("2015")>-1){%>
	parent.document.getElementById("onlineUser").innerHTML="<bean:message bundle="common" key="comm.onlineuser" arg0="<%=userNumStr%>" />";
<%}else{%>
	parent.document.getElementById("userPre").innerHTML="<bean:message bundle="common" key="comm.onlineuser" arg0="<%=userNumStr%>" />";
<%}%>

//setInterval('initRemindInfo()',30000);
function initRemindInfo(){
	var skin = '<%=whir_skin%>';
	var types = "newMail,waitFile,waitRead,";
	var gov_num = '<%=m_ReceiveFileBoxCount%>';
	$.ajax({
		type: 'POST',
		url: whirRootPath+"/SystemRemind!getRemindStr.action?types="+types+"&tmp=<%=new Date().getTime()%>",
        async: true,
		dataType: 'text',
		success: function(data) {
			data = data.replace(/\n|\r/igm,'');
			var resultArr = data.split("|");
			var resultStr = "";
			if(resultArr != null && resultArr.length > 0){
				for(var i=0;i<resultArr.length;i++){
					var name=resultArr[i].split(",")[0];
					var count=resultArr[i].split(",")[1];
					var mailRemindType = '<%=mailRemindType%>';
					if(name=="newMail"){//新邮件
						if(mailRemindType=='1'){
							count = '<%=exchangeMailNum%>';
						}
						if(skin.indexOf("2013")>-1){
							if(parseInt(count)>0){
								//$("#mail_num",window.parent.document).html('<span class="top_l"></span><span class="top_r">'+(parseInt(count)>99?count:count)+'</span>'); 
								$("#newMail",window.parent.document).attr("class","hint_area");
								$("#newMail",window.parent.document).html(count);           
							}else{
								//$("#mail_num",window.parent.document).html('');
								$("#newMail",window.parent.document).html('');   
								$("#newMail",window.parent.document).removeClass("hint_area");
							}
						}else if(skin.indexOf("2012")>-1){
							if(parseInt(count)>0){
								$("#mail_num",window.parent.document).html('<div class="topread_box"><font size=10>'+(parseInt(count)>99?count:count)+'</font></div>');           
							}else{
								$("#mail_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("metro")>-1){
							if(parseInt(count)>0){
								$("#mail_num",window.parent.document).html('(<span>'+(parseInt(count)>99?count:count)+'</span>)');           
							}else{
								$("#mail_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("2011")>-1){
							if(parseInt(count)>0){
								$("#mail_num",window.parent.document).html('<span class="top_l"></span><span class="top_r">'+(parseInt(count)>99?count:count)+'</span>');           
							}else{
								$("#mail_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("2015")>-1){
							if(parseInt(count)>0){
								if(window.parent.document.getElementById("mail_num")){
									$("#mail_num",window.parent.document).remove();
								}
								$("#top_box2",window.parent.document).prepend('<a href="#" class="top_a01" style="left:130px;" id=mail_num><span class="top_l"></span><span class="top_r">'+(parseInt(count)>99?count:count)+'</span></a>'); 
							}else{
								$("#mail_num",window.parent.document).remove();
							}
						}
					}
					if(name=="waitFile"){//新待办
						if(skin.indexOf("2013")>-1){
							if(parseInt(count)>0){
								$("#newFile",window.parent.document).attr("class","hint_area");
								$("#newFile",window.parent.document).html(count);          
							}else{
								$("#newFile",window.parent.document).html(''); 
								$("#newFile",window.parent.document).removeClass("hint_area");
							}
						}else if(skin.indexOf("2012")>-1){
							if(parseInt(count)>0){
								$("#fileDeal_num",window.parent.document).html('<div class="topread_box"><font size=10>'+(parseInt(count)>99?count:count)+'</font></div>');          
							}else{
								$("#fileDeal_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("metro")>-1){
							if(parseInt(count)>0){
								$("#fileDeal_num",window.parent.document).html('(<span>'+(parseInt(count)>99?count:count)+'</span>)');          
							}else{
								$("#fileDeal_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("2011")>-1){
							if(parseInt(count)>0){
								$("#fileDeal_num",window.parent.document).html('<span class="top_l"></span><span class="top_r">'+(parseInt(count)>99?count:count)+'</span>');          
							}else{
								$("#fileDeal_num",window.parent.document).html('');
							}
						}else if(skin.indexOf("2015")>-1){
							if(parseInt(count)>0){
								if(window.parent.document.getElementById("fileDeal_num")){
									$("#fileDeal_num",window.parent.document).remove();
								}
								$("#top_box2",window.parent.document).prepend('<a href="#" class="top_a01" id=fileDeal_num><span class="top_l"></span><span class="top_r">'+(parseInt(count)>99?count:count)+'</span></a>');  
							}else{
								$("#fileDeal_num",window.parent.document).remove();
							}
						}
					}
					if(name=="waitRead"){//新待阅,首页暂不显示
						
					}
				}
				
				//if(resultStr!=''){//提示音
					
				//}

				//parent.document.getElementById("remindInfo").innerHTML = resultStr;
			}
			if(gov_num!=''){//新公文
				if(skin.indexOf("2013")>-1){
					if(parseInt(gov_num)>0){
						$("#newGov",window.parent.document).attr("class","hint_area");
						$("#newGov",window.parent.document).html(gov_num);          
					}else{
						$("#newGov",window.parent.document).html('');
						$("#newGov",window.parent.document).removeClass("hint_area");
					}
				}else if(skin.indexOf("2012")>-1){
					if(parseInt(gov_num)>0){
						$("#gov_num",window.parent.document).html('<div class="topread_box"><font size=10>'+(parseInt(gov_num)>99?gov_num:gov_num)+'</font></div>');          
					}else{
						$("#gov_num",window.parent.document).html('');
					}
				}else if(skin.indexOf("metro")>-1){
					if(parseInt(gov_num)>0){
						$("#gov_num",window.parent.document).html('(<span>'+(parseInt(gov_num)>99?gov_num:gov_num)+'</span>)');          
					}else{
						$("#gov_num",window.parent.document).html('');
					}
				}else if(skin.indexOf("2011")>-1){
					if(parseInt(gov_num)>0){
						$("#gov_num",window.parent.document).html('<span class="top_l"></span><span class="top_r">'+(parseInt(gov_num)>99?gov_num:gov_num)+'</span>');          
					}else{
						$("#gov_num",window.parent.document).html('');
					}
				}else if(skin.indexOf("2015")>-1){
					if(parseInt(gov_num)>0){
						if(window.parent.document.getElementById("gov_num")){
							$("#gov_num",window.parent.document).remove();
						}
						$("#top_box2",window.parent.document).prepend('<a href="#" class="top_a01" style="left:70px;" id=gov_num><span class="top_l"></span><span class="top_r">'+(parseInt(gov_num)>99?gov_num:gov_num)+'</span></a>');  
					}else{
						$("#gov_num",window.parent.document).remove();
					}
				}
			}
		}
	});

}
//-->
</SCRIPT>
<%}%>