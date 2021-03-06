<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="../common/taglibs.jsp" %>
<%
String workId = request.getParameter("workId");
String orgId = session.getAttribute("orgId").toString();
String empLivingPhoto = request.getParameter("empLivingPhoto")==null?"":request.getParameter("empLivingPhoto");
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=0,minimal-ui">
    <title>文件办理</title>
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/template.reset.css" />
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/template.icon.css" />
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/template.fa.css" />
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/template.style.css" />
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/alert/template.alert.css" />
    <link rel="stylesheet" href="/defaultroot/evo/weixin/template/css/swiper/template.swiper.css" />
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/mobiscroll/mobiscroll.icons.css"/>
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/mobiscroll/mobiscroll.scroller.css"/>
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/mobiscroll/mobiscroll.scroller.ios7.css"/>
    <link rel="stylesheet" type="text/css" href="/defaultroot/evo/weixin/template/css/mobiscroll/mobiscroll.animation.css"/>
</head>
<body>
<c:if test="${not empty docXml}">
	<x:parse xml="${docXml}" var="doc"/>
	<c:if test="${not empty workInfoDocXml}">
		<x:parse xml="${workInfoDocXml}" var="workInfoDoc"/>
		<!-- 此流程发起的时间 -->
		<c:set var="worksubmittime"><x:out select="$workInfoDoc//workInfo/worksubmittime/text()"/></c:set>
		<!-- true表示与退回按钮 -->
		<c:set var="hasbackbutton"><x:out select="$workInfoDoc//workInfo/havebackbutton/text()"/></c:set>
		<!-- 当前所处的办理 -->
		<c:set var="workcurstep"><x:out select="$workInfoDoc//workInfo/workcurstep/text()"/></c:set>
		<!-- 流程标题 -->
		<c:set var="worktitle"><x:out select="$workInfoDoc//workInfo/worktitle/text()"/></c:set>
		<!-- 能显示的按钮 -->
		<c:set var="modibutton"><x:out select="$workInfoDoc//workInfo/modibutton/text()"/></c:set>
		<!-- 此待办的Id  wf_work 的主键id -->
		<c:set var="wfworkId"><x:out select="$workInfoDoc//workInfo/wf_work_id/text()"/></c:set>
		<!-- 是否有短信权限 0：没有 1：有 -->
		<c:set var="wfsmsRight"><x:out select="$workInfoDoc//smsRight/text()"/></c:set>
		<!-- 头像文件名 -->
		<c:set var="EmpLivingPhoto"><x:out select="$workInfoDoc//workInfo/empLivingPhoto/text()"/></c:set>
		<c:if test="${not empty EmpLivingPhoto}"><c:set var="EmpLivingPhoto">/defaultroot/upload/peopleinfo/${EmpLivingPhoto}</c:set></c:if>
	    <form id="sendForm" action="/defaultroot/workflow/sendnew.controller" method="post">
	    <section class="wh-section wh-section-bottomfixed" id="mainContent">
    		<article class="wh-edit wh-edit-document">
    			<div>
		            <div class="wh-article-lists">
		            	 <ul>
		                    <li>
		                    	<strong class="document-icon">
		                    		<img src="${EmpLivingPhoto eq '' || EmpLivingPhoto eq null ? '/defaultroot/evo/weixin/images/head.png' : EmpLivingPhoto}">
		                    	</strong>
		                    	<p>
			                    	<a href="javascript:void(0);">${worktitle} 当前环节为：${workcurstep}</a>
			                    	<span>（${fn:substring(worksubmittime,0,16)}）</span>
		                    	</p>
		                    </li>
		                </ul>
		            </div>
	            	<table class="wh-table-edit">
	            	<!-- ssMode2:出库 or 3:退库 -->
	            	<c:set var="ssMode"><x:out select="$doc//fieldList/ssMode/text()"/></c:set>
	            	<!-- 出库单号/退库单号 -->
	            	<c:set var="serial"><x:out select="$doc//fieldList/serial/text()"/></c:set>
	            	<!-- 出库仓库ID/退库仓库ID -->
	            	<c:set var="stockId"><x:out select="$doc//fieldList/stockId/text()"/></c:set>
	            	<!-- 出库仓库名称/退库仓库名称 -->
	            	<c:set var="stockName"><x:out select="$doc//fieldList/stockName/text()"/></c:set>
	            	<!-- 出库部门ID/退库部门ID -->
	            	<c:set var="orgId"><x:out select="$doc//fieldList/orgId/text()"/></c:set>
	            	<!-- 出库部门名称/退库部门名称 -->
	            	<c:set var="orgName"><x:out select="$doc//fieldList/orgName/text()"/></c:set>
	            	<!-- 领用人ID/退库人ID -->
	            	<c:set var="ssUseManId"><x:out select="$doc//fieldList/ssUseManId/text()"/></c:set>
	            	<!-- 领用人名称/退库人名称 -->
	            	<c:set var="ssUseMan"><x:out select="$doc//fieldList/ssUseMan/text()"/></c:set>
	            	<!-- 出库类别ID/退库类别ID -->
	            	<c:set var="ssTypeId"><x:out select="$doc//fieldList/ssTypeId/text()"/></c:set>
	            	<!-- 出库日期/退库日期 -->
	            	<c:set var="ssDate"><x:out select="$doc//fieldList/ssDate/text()"/></c:set>
	            	<!-- 出库类别名称/退库类别名称 -->
	            	<c:set var="ssTypeName"><x:out select="$doc//fieldList/ssTypeName/text()"/></c:set>
	            	<!-- 领料部门ID -->
	            	<c:set var="lyDeptId"><x:out select="$doc//lyDeptId/ssDate/text()"/></c:set>
	            	<!-- 领料部门名称 -->
	            	<c:set var="lyDeptName"><x:out select="$doc//fieldList/lyDeptName/text()"/></c:set>
	            	<!-- 用途 -->
	            	<c:set var="uses"><x:out select="$doc//fieldList/uses/text()"/></c:set>
	            	<!-- 备注 -->
	            	<c:set var="remark"><x:out select="$doc//fieldList/remark/text()"/></c:set>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库单号</c:if>
								<c:if test="${ssMode == '3'}">退库单号</c:if>
							</th>
							<td>${serial }</td>
						</tr>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库仓库</c:if>
								<c:if test="${ssMode == '3'}">退库仓库</c:if>
							</th>
							<td>${stockName } </td>
						</tr>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库部门</c:if>
								<c:if test="${ssMode == '3'}">退库部门</c:if>
							</th>
							<td>${orgName }</td>
						</tr>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库人</c:if>
								<c:if test="${ssMode == '3'}">退库人</c:if>
							</th>
							<td>${ssUseMan }</td>
						</tr>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库日期</c:if>
								<c:if test="${ssMode == '3'}">退库日期</c:if>
							</th>
							<td>${ssDate }</td>
						</tr>
						<tr>
							<th>
								<c:if test="${ssMode == '2'}">出库类别</c:if>
								<c:if test="${ssMode == '3'}">退库类别</c:if>
							</th>
							<td>${ssTypeName }</td>
						</tr>
						<tr>
							<th>用途</th>
							<td>${uses }</td>
						</tr>
						<tr>
							<th>备注</th>
							<td>${remark }</td>
						</tr>
						<!--子表信息begin-->
						<c:set var="subTable"></c:set>
						<x:forEach select="$doc//subTableList/subFieldList" var="ct" varStatus="xh">
							<c:set var="subTable" >${xh.index+1}</c:set>
						</x:forEach>
						<tr>
							<th>子表填写：</th>
							<td>
								<input id="subTableInput" placeholder="添加子表" type="text" class="edit-ipt-r edit-ipt-arrow" 
								<c:if test="${not empty subTable}">value="${subTable}条子表数据"</c:if>
								 readonly="readonly" onclick="addSubTable('1');"/>
							</td>
						</tr>
						<!--子表信息end-->
					    <!--批示意见begin-->
				    	<c:if test="${param.workStatus eq '0'}">
				    		<c:set var="commentField" ><x:out select="$workInfoDoc//workInfo/commentField/text()"/></c:set>
							<c:set var="actiCommFieldType" ><x:out select="$workInfoDoc//workInfo/actiCommFieldType/text()"/></c:set>
							<c:if test="${actiCommFieldType != '-1' && (commentField == '-1' || commentField == 'nullCommentField' || commentField == 'autoCommentField' || commentField == 'null') }">
							<tr>
								<th>
								<c:if test="${commentmustnonull eq true}">
										<i class="fa fa-asterisk"></i>
									</c:if>
								审批意见：
								</th>
								<td>
		                            <textarea class="edit-txta edit-txta-l" placeholder="请输入文字" name="comment_input" id="comment_input" maxlength="50"></textarea>
									<%--<a href="#" class="edit-slt-r">常用语审批</a>--%>
									<div class="examine" style="text-align:right;">
										<a class="edit-select edit-ipt-r">
											<div class="edit-sel-show">
												<span>常用审批语</span>
											</div>    
											<select class="btn-bottom-pop" onchange="selectComment(this);">
												<option value="0">常用审批语</option> 
												<x:forEach select="$workInfoDoc//officelist" var="selectvalue" >
													<option value='<x:out select="$selectvalue/text()"/>'><x:out select="$selectvalue/text()"/></option>
											    </x:forEach>
											</select>
										</a>
									</div>
			                    </td>
							</tr>
							</c:if>
				    	</c:if>
						<c:if test="${param.workStatus eq '2'}">
				    		<c:set var="passRoundCommField" ><x:out select="$workInfoDoc//workInfo/passRoundCommField/text()"/></c:set>
							<c:set var="passRoundCommFieldType" ><x:out select="$workInfoDoc//workInfo/passRoundCommFieldType/text()"/></c:set>
							<c:if test="${passRoundCommField == 'autoCommentField'}">
							<tr>
								<th>
								<c:if test="${commentmustnonull eq true}">
										<i class="fa fa-asterisk"></i>
									</c:if>
								审批意见：
								</th>
								<td>
		                            <textarea class="edit-txta edit-txta-l" placeholder="请输入文字" name="comment_input" id="comment_input" maxlength="50"></textarea>
									<%--<a href="#" class="edit-slt-r">常用语审批</a>--%>
									<div class="examine" style="text-align:right;">
										<a class="edit-select edit-ipt-r">
											<div class="edit-sel-show">
												<span>常用审批语</span>
											</div>    
											<select class="btn-bottom-pop" onchange="selectComment(this);">
												<option value="0">常用审批语</option> 
												 <x:forEach select="$workInfoDoc//officelist" var="selectvalue" >
													<option value='<x:out select="$selectvalue/text()"/>'><x:out select="$selectvalue/text()"/></option>
											     </x:forEach>
											</select>
										</a>
									</div>
			                    </td>
							</tr>
							</c:if>
				    	</c:if>
						<x:forEach select="$workInfoDoc//commentList/comment" var="ct" >
							<c:set var="commentType"><x:out select="$ct//type/text()"/></c:set>
							<c:set var="commentContent"><x:out select="$ct//content/text()"/></c:set>
							<tr>
								<th><x:out select="$ct//step/text()"/>：</th>
								<td><x:out select="$ct//content/text()"/>&nbsp;&nbsp;<x:out select="$ct//person/text()"/>(<x:out select="$ct//date/text()"/>)</td>
							</tr>
						</x:forEach>
						<!--批示意见end-->
	            	</table>
            	</div>
    		</article>
   		</section>
		<input type="hidden" name="tableId" value="<%=workId%>" />
		<input type="hidden" name="recordId" value="<x:out select="$workInfoDoc//workInfo/workrecord_id/text()"/>" />
		<input type="hidden" name="activityId" value="<x:out select="$workInfoDoc//workInfo/initactivity/text()"/>" />
		<input type="hidden" name="workId" value="<x:out select="$workInfoDoc//workInfo/wf_work_id/text()"/>" />
		<input type="hidden" name="stepCount" value="<x:out select="$workInfoDoc//workInfo/workstepcount/text()"/>" />
		<input type="hidden" name="isForkTask" value="<x:out select="$workInfoDoc//isForkTask/text()"/>" />
		<input type="hidden" name="forkStepCount" value="<x:out select="$workInfoDoc//forkStepCount/text()"/>" />
		<input type="hidden" name="forkId" value="<x:out select="$workInfoDoc//forkId/text()"/>" />
		<input type="hidden" name="activityclass" value="<x:out select="$workInfoDoc//activityClass/text()"/>" />
		<input type="hidden" name="commentType" value="0" />
		<input type="hidden" name="pass_title" value="" />
		<input type="hidden" name="pass_time" value="" />
		<input type="hidden" name="pass_person" value="" />
		<input type="hidden" name="__sys_operateType" value="2" />
		<input type="hidden" name="__sys_infoId" value='<x:out select="$workInfoDoc//paramList/workrecord_id/text()"/>' />
		<input type="hidden" name="__sys_pageId" value='<x:out select="$workInfoDoc//paramList/worktable_id/text()"/>' />
		<input type="hidden" name="__sys_formType" value='<x:out select="$workInfoDoc//paramList/formType/text()"/>' />	
		<input type="hidden" name="__main_tableName" value='<x:out select="$workInfoDoc//fieldList/tableName/text()"/>' />	
		<input type="hidden" name="actiCommFieldType" value='<x:out select="$workInfoDoc//workInfo/actiCommFieldType/text()"/>' />
		<input type="hidden" name="curCommField" value='<x:out select="$workInfoDoc//workInfo/commentField/text()"/>' />
		<input type="hidden" name="trantype" value='<x:out select="$workInfoDoc//workInfo/trantype/text()"/>' />
		<x:if select="$workInfoDoc//workInfo/commentmustnonull" var="commentmustnonull">
			<input type="hidden" name="commentmustnonull" value='<x:out select="$workInfoDoc//workInfo/commentmustnonull/text()"/>' />
		</x:if>
		<x:if select="$workInfoDoc//workInfo/backnocomment" var="backnocomment">
			<input type="hidden" name="backnocomment" value='<x:out select="$workInfoDoc//workInfo/backnocomment/text()"/>' />
		</x:if>
		<x:if select="$workInfoDoc//workInfo/backMailRange" var="backMailRange">
			<input type="hidden" name="backMailRange" value='<x:out select="$workInfoDoc//workInfo/backMailRange/text()"/>' />
		</x:if>
		<x:if select="$workInfoDoc//workInfo/smsRight" var="smsRight">
			<input type="hidden" name="smsRight" value='<x:out select="$workInfoDoc//workInfo/smsRight/text()"/>' />
		</x:if>
		<input type="file" style="display:none;" value="" name="comment_input_shouxie" id="comment_input_shouxie"/>
		<input type="file" style="display:none;" value="" name="comment_input_yuyin" id="comment_input_yuyin"/>
		<input type="hidden" name="empLivingPhoto" value="${EmpLivingPhoto}">
		<input type="hidden" name="worktitle" value="${worktitle}">
		<input type="hidden" name="workcurstep" value="${workcurstep}">
		<input type="hidden" name="worksubmittime" value="${worksubmittime}">
		<input type="hidden" name="workStatus" value="0">
	</form>
	</c:if>
	<c:if test="${param.workStatus ne '102'}">
		<footer class="wh-footer wh-footer-forum" id="footerButton">
		    <div class="wh-wrapper">
		        <div class="wh-container">
		            <div class="wh-footer-btn">
						<c:choose>
							<c:when test="${param.workStatus eq '0'}">
								<div class="fbtn-more-nav">
				                    <div class="fbtn-more-nav-inner">
				                    	<c:if test="${fn:indexOf(modibutton,'Tran') >0}">
				                        	<a href="javascript:$('#tranInfoForm').submit();" class="fbtn-matter col-xs-12"><i class="fa fa-share"></i>转办</a>
				                        </c:if>
				                        <c:if test="${fn:indexOf(modibutton,'AddSign') >0}">
				                        	<a href="javascript:$('#addSignForm').submit();" class="fbtn-matter col-xs-12"><i class="fa fa-plus"></i>加签</a>
				                        </c:if>
				                    </div>
				                    <div class="fbtn-more-nav-arrow"></div>
				                </div>
				                <c:choose>
					                <c:when test="${hasbackbutton == 'true' }">
						               	<a href="javascript:$('#backForm').submit();" class="fbtn-cancel col-xs-5"><i class="fa fa-arrow-left"></i>退回</a>
						                <a href="javascript:$('#sendForm').submit();" class="fbtn-matter col-xs-5"><i class="fa fa-check-square"></i>发送</a>
					                </c:when>
					                <c:otherwise>
						                <a href="javascript:$('#sendForm').submit();" class="fbtn-matter col-xs-10"><i class="fa fa-check-square"></i>发送</a>
					                </c:otherwise>
				                </c:choose>
				                <span id="fbtnMore" class="fbtn-matter col-xs-2"><i class="fa fa-bars"></i></span>
							</c:when>
							<c:when test="${param.workStatus eq '2'}">
								<a href="javascript:workfolwSend('${wfworkId}');" class="fbtn-matter col-xs-6 fbtn-single"><i class="fa fa-check-square"></i>发送</a>
							</c:when>
							<c:when test="${param.workStatus eq '101'}">
								<c:if test="${fn:indexOf(workcurstep,'办理完毕') == '-1'}">
				            	<c:choose>
				            		<c:when test="${fn:indexOf(modibutton,'Undo') >0 && fn:indexOf(modibutton,'Wait') >0}">
				            			<a href="javascript:workfolwUndo('${wfworkId}');" class="fbtn-cancel col-xs-6"><i class="fa fa-retweet"></i>撤办</a>
				            			<a href="javascript:document.getElementById('sendFormAgain').submit();" class="fbtn-matter col-xs-6"><i class="fa fa-thumb-tack"></i>催办</a>
				            		</c:when>
				            		<c:when test="${fn:indexOf(modibutton,'Undo') >0 && fn:indexOf(modibutton,'Wait') <=0}">
				            			<a href="javascript:workfolwUndo('${wfworkId}');" class="fbtn-cancel col-xs-6 fbtn-single"><i class="fa fa-retweet"></i>撤办</a>
				            		</c:when>
				            		<c:when test="${fn:indexOf(modibutton,'Undo') <=0 && fn:indexOf(modibutton,'Wait') >0}">
				            			<a href="javascript:document.getElementById('sendFormAgain').submit();" class="fbtn-matter col-xs-6 fbtn-single"><i class="fa fa-thumb-tack"></i>催办</a>
				            		</c:when>
				            	</c:choose>
								</c:if>
							</c:when>
							<c:when test="${param.workStatus eq '1100'}">
								<c:if test="${fn:indexOf(modibutton,'Wait') >0}">
									<a href="javascript:document.getElementById('sendFormAgain').submit();" class="fbtn-matter col-xs-6 fbtn-single"><i class="fa fa-check-square"></i>催办</a>
								</c:if>
							</c:when>
						</c:choose>
		            </div>
		        </div>
		    </div>
		</footer>
		<jsp:include page="../common/include_stock_subTable.jsp" flush="true">
			<jsp:param name="docXml" value="${docXml}" />
			<jsp:param name="orgId" value="<%=orgId %>" />
		</jsp:include>
	</c:if>
	<form id="sendFormAgain" action="/defaultroot/dealfile/pressInfo.controller?workId=${wfworkId}&amp;smsRight=${wfsmsRight }" method="post">
		<input type="hidden" name="empLivingPhoto" value="${EmpLivingPhoto}">
		<input type="hidden" name="worktitle" value="${worktitle}">
		<input type="hidden" name="workcurstep" value="${workcurstep}">
		<input type="hidden" name="worksubmittime" value="${worksubmittime}">
		<input type="hidden" name="workStatus" value="1100">
	</form>
	
	<form id="backForm" action="/defaultroot/workflow/back.controller" method="post">
		<input type="hidden" name="workId" value="<%=workId%>">
		<input type="hidden" name="empLivingPhoto" value="${EmpLivingPhoto}">
		<input type="hidden" name="worktitle" value="${worktitle}">
		<input type="hidden" name="workcurstep" value="${workcurstep}">
		<input type="hidden" name="worksubmittime" value="${worksubmittime}">
		<input type="hidden" name="workStatus" value="0">
		<input type="hidden" name="tableId" value='<x:out select="$workInfoDoc//workInfo/worktable_id/text()"/>'>
		<input type="hidden" name="recordId" value='<x:out select="$workInfoDoc//workInfo/workrecord_id/text()"/>'>
		<input type="hidden" name="stepCount" value='<x:out select="$workInfoDoc//workInfo/workstepcount/text()"/>'>
		<input type="hidden" name="forkId" value='<x:out select="$workInfoDoc//workInfo/forkId/text()"/>'>
		<input type="hidden" name="forkStepCount" value='<x:out select="$workInfoDoc//workInfo/forkStepCount/text()"/>'>
		<input type="hidden" name="isForkTask" value='<x:out select="$workInfoDoc//workInfo/isForkTask/text()"/>'>
		<input type="hidden" name="curCommField" value='<x:out select="$workInfoDoc//workInfo/commentField/text()"/>' />
	</form>
	<!----------转办开始---------->
	<form id="tranInfoForm" class="dialog" action="/defaultroot/dealfile/tranInfo.controller?workId=${wfworkId}" method="post">
		<input type="hidden" name="empLivingPhoto" value="${EmpLivingPhoto}">
		<input type="hidden" name="worktitle" value="${worktitle}">
		<input type="hidden" name="workcurstep" value="${workcurstep}">
		<input type="hidden" name="worksubmittime" value="${worksubmittime}">
		<input type="hidden" name="workStatus" value="0">
	</form>
	<!----------转办结束---------->
	<!----------加签开始---------->
	<form id="addSignForm" class="dialog" action="/defaultroot/dealfile/addSign.controller?workId=${wfworkId}" method="post">
		<input type="hidden" name="empLivingPhoto" value="${EmpLivingPhoto}">
		<input type="hidden" name="worktitle" value="${worktitle}">
		<input type="hidden" name="workcurstep" value="${workcurstep}">
		<input type="hidden" name="worksubmittime" value="${worksubmittime}">
		<input type="hidden" name="workStatus" value="0">
	</form>
	<!----------加签结束---------->
</c:if>
</body>
</html>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/zepto.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/touch.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/fx.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/swiper/swiper.min.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/selector.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/alert/zepto.alert.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.zepto.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.datetime.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.select.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/template/js/mobiscroll/mobiscroll.scroller.ios7.js"></script>
<script type="text/javascript" src="/defaultroot/evo/weixin/js/subClick.js"></script>
<script type="text/javascript">
    var dialog = null;
    function pageLoading(){
        dialog = $.dialog({
            content:"页面加载中...",
            title: 'load'
        });
    }

    $(function(){
    	//更多菜单展开
        var fbtnMore = $("#fbtnMore");
        var fbtnMoreCon = $(".fbtn-more-nav");
        $(".wh-section").click(function(){
            fbtnMoreCon.hide();
        })
        fbtnMoreCon.hide();
        fbtnMore.click(function(){
            fbtnMoreCon.toggle();
        });
        
        //演示1
        $("#demo-1").tap(function(){
            $.dialog({
                content:"数据加载中...",
                title: 'ok',
                time:2000
            });
        })
        $("#scroller").mobiscroll().date();
        //初始化日期控件
        var opt = {
            preset: 'datetime', //日期，可选：date\datetime\time\tree_list\image_text\select
            theme: 'ios7', //皮肤样式，可选：default\android\android-ics light\android-ics\ios\jqm\sense-ui\wp light\wp
            display: 'bottom', //显示方式 ，可选：modal\inline\bubble\top\bottom
            mode: 'scroller', //日期选择模式，可选：scroller\clickpick\mixed
            lang:'zh',
            dateFormat: 'yy-mm-dd', // 日期格式
            timeFormat: 'HH:ii',
            timeWheels:'HHii',
            setText: '确定', //确认按钮名称
            cancelText: '取消',//取消按钮名籍我
            dateOrder: 'yymmdd', //面板中日期排列格式
            monthNames:['01','02','03','04','05','06','07','08','09','10','11','12'],
            dayText: '日',
            monthText: '月',
            yearText: '年',
            hourText:'时',
            minuteText:'分',
            amText:'',
            pmText:'',
            showNow: false,
            startYear:1999,
            endYear:2099
        };
        $("#scroller").mobiscroll(opt);
    });
    
   	function workfolwSend(workId){
		//发送流程
		$.ajax({
			url : '/defaultroot/workflow/readover.controller',
			type : 'post',
			data : $('#sendForm').serialize(),
			success : function(data){
				if(data){
					var jsonData = eval('('+data+')');
					console.info(jsonData.result);
					if(jsonData.result = 'success'){
						alert('发送成功！');
						window.location = '/defaultroot/dealfile/list.controller?workStatus=0';
					}
				}else{
					alert('发送失败！');
				}
			},
			error : function(){
				alert('发送异常！');
			}
		});
	}
	
	function workfolwUndo(workId){
		var status = confirm('是否撤回该流程到您的待办文件中重新办理？');
        if(!status){
            return false;
        }
		var dialog = $.dialog({
	            content:"正在撤办中...",
	            title: 'load'
	        });
		var url ='/defaultroot/workflow/workfolwUndo.controller?workId='+workId;
		var openUrl ='/defaultroot/dealfile/list.controller?workStatus=101';
		$.ajax({
			type:'POST',
			url: url,
			async: true,
			dataType: 'text',
			success: function(data){
				if(dialog){
					dialog.close();
				}
				var json = eval("("+data+")");
				if(json!=null){
					if(json.result == 'success'){
						alert("撤办成功！");
						window.location.href =openUrl;
					}else{
						alert("撤办失败！");
					}
				}
			},
			error: function(){
				alert("异常！");
			}
		});
	}
	
	//选择批示意见
    function selectComment(obj){
    	var $selectObj = $(obj);
    	var selectVal = $selectObj.val();
    	if(selectVal == '0'){
        	selectVal = '';
        }
    	var $textarea = $selectObj.parent().parent().siblings();
    	setSpanHtml(obj,selectVal);
    	$textarea.val($textarea.val() + selectVal);
    }
  //设置span中的值
	function setSpanHtml(obj,selectVal){
    	if(!selectVal){
    		selectVal = $(obj).find("option:selected").text();
    	}
		$(obj).parent().find('div>span').html(selectVal);
	}
</script>