<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.text.DateFormat"%>
<%
  String PstockName = com.whir.component.security.crypto.EncryptUtil.htmlcode(request,"stockName");	
  //String PstockName =request.getParameter("stockName")==null?"":request.getParameter("stockName");
  String AstockName =request.getAttribute("stockName")==null?"":request.getAttribute("stockName").toString();
  AstockName =com.whir.component.security.crypto.EncryptUtil.htmlcode(AstockName);

  String local     = session.getAttribute("org.apache.struts.action.LOCALE").toString();
  //String mode      = request.getParameter("mode")==null?"stock":request.getParameter("mode");
  String mode = com.whir.component.security.crypto.EncryptUtil.htmlcode(request,"mode");
  if("".equals(mode)){
	  mode ="stock";
  }
  String flowTitle = PstockName+(mode.equals("stock")?"采购进货":"物品退货");
  Calendar now  = Calendar.getInstance();
  DateFormat df = DateFormat.getDateInstance(DateFormat.LONG, Locale.CHINESE);

  String stockId =com.whir.component.security.crypto.EncryptUtil.htmlcode(request,"stockId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%=mode.equals("stock")?"采购进货":"物品退货"%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
	<%@ include file="/public/include/meta_base.jsp"%>
	<%@ include file="/public/include/meta_detail.jsp"%>
	<!--这里可以追加导入模块内私有的js文件或css文件-->
	<style>
		.TBStyle{
		    BACKGROUND-COLOR: #ffffff;
		    BORDER-BOTTOM: #000000 0px solid;
		    BORDER-LEFT: #000000 0px solid;
		    BORDER-RIGHT: #000000 1px solid;
		    BORDER-TOP: #000000 1px solid;
		    TEXT-DECORATION: none;
		    COLOR: #000000;
		}
		
		.TDStyle{}
		.TDStyle td{
		    BACKGROUND-COLOR: #ffffff;
		    BORDER-BOTTOM: #000000 1px solid;
		    BORDER-LEFT: #000000 1px solid;
		    BORDER-RIGHT: #000000 0px solid;
		    BORDER-TOP: #000000 0px solid;
		    TEXT-DECORATION: none;
		    COLOR: #000000;
		}
		
		.TDTitleStyle{}
		.TDTitleStyle td{
		    BACKGROUND-COLOR: menu;
		    BORDER-BOTTOM: #000000 1px solid;
		    BORDER-LEFT: #000000 1px solid;
		    BORDER-RIGHT: #000000 0px solid;
		    BORDER-TOP: #000000 0px solid;
		    TEXT-DECORATION: none;
		    COLOR: #000000;
		}
	</style>
</head>
<body class="Pupwin">
	<div class="BodyMargin_10">
		<div class="docBoxNoPanel">
	       <s:form name="dataForm" id="dataForm" action="/intoStockAction!saveIntoStock.action" method="post" theme="simple" >
              <%@ include file="/public/include/form_detail.jsp"%>
	          <table width="98%" border="0" cellpadding="2" cellspacing="0" class="Table_bottomline" style="margin:0 auto;">
		          <s:hidden name="ptMasterPO.id" />
		          <tr>
				     <td width="9%" class="td_lefttitle" nowrap><%=mode.equals("stock")?"入库":"退货"%>仓库：</td>
				     <td width="89%" colspan="3">
				         <%=AstockName%>
				         <s:hidden name="ptMasterPO.ptStock" id="ptStock" value="%{#request.stockId}" />
				         <s:hidden name="ptMasterPO.ptMoney" id="ptMoney" value="" />
				         <input type="hidden" name="stockName" value="<%=PstockName%>">
				         <input type="hidden" name="flowTitle" value="<%=flowTitle%>" >
				         <input type="hidden" name="stockId" value="<%=stockId%>">
				         <input type="hidden" name="mode" value="<%=mode%>">
				     </td>
				  </tr>
		          
		          <%
				    List typeDefineList = (List)request.getAttribute("typeDefineList");
				  %>
		          
		          <tr>
				      <td for="<%=mode.equals("stock")?"入库":"退货"%>部门" width="9%" class="td_lefttitle" nowrap><%=mode.equals("stock")?"入库":"退货"%>部门<span class="MustFillColor">*</span>：</td>
				      <td width="40%">
				          <s:hidden name="ptMasterPO.ptOrg" id="ptOrg" value="%{#request.orgId}"/><s:textfield name="ptMasterPO.ptOrgName" id="ptOrgName" cssClass="inputText" cssStyle="width:98%;" whir-options="vtype:['notempty']" readonly="true" value="%{#request.orgName}"/><a href="javascript:void(0);" class="selectIco" onclick="openSelect({allowId:'ptOrg', allowName:'ptOrgName', select:'org', single:'yes', show:'org', range:'*0*'});"></a>
				      </td>
				      <td width="9%" class="td_lefttitle" nowrap><%=mode.equals("stock")?"入库":"退货"%>类别：</td>
				      <td width="40%">
				          <select name="ptTypeDefine" id="ptTypeDefine" class="easyui-combobox" data-options="width:202,panelHeight:'150'" editable="false">
						  	<option value="-1"><s:text name='comm.select2'/></option>
						  	<%
				            if(typeDefineList !=null && typeDefineList.size() >0){
				               for(int i = 0 ;i<typeDefineList.size();i++){
				             	   Object []obj = (Object[])typeDefineList.get(i);
						  	%>
				            <option value="<%=obj[0]%>"><%=obj[1]%></option>
						  	<%}}%>
				          </select>
				      </td>
				  </tr>
				  
				  <tr>
				     <td width="9%" class="td_lefttitle" nowrap><%=mode.equals("stock")?"供货单位":"退货单位"%>：</td>
				     <td width="40%">
				         <s:select name="ptMasterPO.ptSupp" id="ptSupp" list="%{#request.supplyUnitList}" listKey="unitName"  listValue="unitName" headerKey="" headerValue="" cssClass="easyui-combobox" data-options="width:202,panelHeight:'150'"/>
				         <s:hidden name="ptMasterPO.ptMan" id="ptMan" value="%{#request.userName}" />
				     </td>
				     <td for="<%=mode.equals("stock")?"入库":"退货"%>日期" width="9%" class="td_lefttitle" nowrap><%=mode.equals("stock")?"入库":"退货"%>日期<span class="MustFillColor">*</span>：</td>
				     <td width="40%">
				         <s:textfield name="ptMasterPO.ptDate" id="ptDate" whir-options="vtype:['notempty']" cssClass="Wdate whir_datebox" onclick="WdatePicker({el:'ptDate',dateFmt:'yyyy-MM-dd',readOnly:true})" >
	                         <s:param name="value"><s:date name="ptMasterPO.ptDate" format="yyyy-MM-dd"/></s:param>
	                     </s:textfield>
				     </td>
				  </tr>
				  
				  <tr>
				     <td for="经手人" width="9%" class="td_lefttitle" nowrap>经手人：</td>
				     <td width="40%">
				         <s:textfield name="ptMasterPO.ptHandleName" id="ptHandleName" maxLength="20" whir-options="vtype:[{'maxLength':20}]" value="%{#request.userName}" cssClass="inputText" cssStyle="width:98%;" />
				     </td>
				     <td for="发票号码" width="9%" class="td_lefttitle" nowrap>发票号码：</td>
				     <td width="40%">
				         <s:textfield name="ptMasterPO.invoiceNO" id="invoiceNO" maxLength="20" whir-options="vtype:[{'maxLength':20}]" cssClass="inputText" cssStyle="width:98%;" />
				     </td>
				  </tr>
				  
				  <tr>
				     <td for="备注" width="9%" class="td_lefttitle" nowrap>备注：</td>
				     <td width="89%" colspan="3">
				         <s:textarea name="ptMasterPO.remark" id="remark" cssClass="inputTextarea" cols="112" rows="3" cssStyle="width:99%;" whir-options="vtype:[{'maxLength':100}]"></s:textarea>
				     </td>
				  </tr>
				  
				  <tr>
				     <td class="td_lefttitle" colspan="4" nowrap>
				         <input type="button" class="btnButton4font" style="margin-bottom:5px;" onclick="addGoods('<%=mode%>','<%=stockId%>');" value="<s:text name="comm.add"/>" /><span class="MustFillColor">*</span>
				     </td>
				  </tr>
				  
				  <tr>
				     <td class="td_lefttitle" colspan="4" nowrap>
				         <table width="99.5%" border="0" cellpadding="0" cellspacing="0" id="detailTable" class="TBStyle">
				              <tr id="startTr" class="TDTitleStyle">
				              	  <td width="10%" align="center" height="25"><%=mode.equals("stock")?"存货编号":"退货编号"%></td>
				              	  <td width="20%" align="center"><%=mode.equals("stock")?"存货名称":"退货名称"%></td>
				              	  <td width="10%" align="center">规格型号</td>
				              	  <td width="10%" align="center">计量单位</td>
				              	  <td width="15%" align="center">数量</td>
				              	  <td width="10%" align="center">单价</td>
				              	  <td width="15%" align="center">金额</td>
				              	  <td width="10%" align="center">操作</td>
				              </tr>
				              <tr id="endTr" class="TDStyle">
				             	  <td align="center" height="25">合计</td>
				             	  <td>&nbsp;</td>
				             	  <td>&nbsp;</td>
				             	  <td>&nbsp;</td>
				             	  <td><input type="text" name="sum_num" id="sum_num" class="inputText" size="10" readonly="readonly"></td>
				             	  <td>&nbsp;</td>
				             	  <td><input type="text" name="sum_money" id="sum_money" class="inputText" size="10" readonly="readonly"></td>
				             	  <td>&nbsp;</td>
				              </tr>
				         </table>
				     </td>
				  </tr>
				  
				  <tr>
				     <td width="9%" class="td_lefttitle" nowrap>制单人：</td>
				     <td width="40%"><s:property value="%{#request.userName}"/></td>
				     <td width="9%" class="td_lefttitle" nowrap>审核人：</td>
				     <td width="40%">&nbsp;</td>
				  </tr>
				  
	              <tr>
				     <td width="9%" class="td_lefttitle" nowrap>制单日期：</td>
				     <td width="40%"><%=df.format(now.getTime())%></td>
				     <td width="9%" class="td_lefttitle" nowrap>审核时间：</td>
				     <td width="40%">&nbsp;</td>
				  </tr>
				  
				  <tr>
				     <td width="9%" class="td_lefttitle" nowrap>审核状态：</td>
				     <td width="40%">未审核</td>
				     <td width="9%" class="td_lefttitle" nowrap>&nbsp;</td>
				     <td width="40%">&nbsp;</td>
				  </tr>
				  
		          <tr class="Table_nobttomline">
	                   <td></td>
	                   <td nowrap>
	                      <input type="button" class="btnButton4font" onClick="saveAndExit(this);" value="<s:text name="comm.saveclose"/>" />
	                      <input type="button" class="btnButton4font" onClick="resetDataForm(this);" value="<s:text name="comm.reset"/>" />
	                      <input type="button" class="btnButton4font" onClick="window.close();" value="<s:text name="comm.exit"/>" />
	                   </td>
	              </tr>
	          </table>
	       </s:form>
		</div>
	</div>
</body>
<script type="text/javascript">
	//*************************************下面的函数属于公共的或半自定义的*************************************************//
	
	//设置表单为异步提交
	initDataFormToAjax({"dataForm":'dataForm',"queryForm":'queryForm',"tip":'保存'});
	
	//*************************************下面的函数属于各个模块 完全 自定义的*************************************************//
	
    //2013-08-06-----禁止Backspace-----start
	$(document).keydown(function(e){
        var doPrevent;
        var varkey =(e.keyCode) || (e.which) || (e.charCode);
        if(varkey ==8){
        	 var d = e.srcElement || e.target;
        	 if(d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA'){
        	 	doPrevent = d.readOnly || d.disabled;
        	 	if(d.type.toUpperCase() == 'SUBMIT' || d.type.toUpperCase() == 'RADIO' || d.type.toUpperCase() == 'CHECKBOX' || d.type.toUpperCase() == 'BUTTON'){
        	 		doPrevent = true;
        	 	}
        	 }else{
        	 	doPrevent = true;
        	 }
        }
        if(doPrevent){
        	e.preventDefault();
        }
    });
    //2013-08-06-----禁止Backspace-----end
    
    function saveAndExit(obj){
    	var text ='<%=mode.equals("stock")?"供货单位":"退货单位"%>';
    	//var ptSuppText =whirCombobox.getText('ptSupp');
    	//if(ptSuppText ==null || ptSuppText ==''){
    	//    whirCombobox.setValue('ptSupp', '');
    	//}
    	var ptSuppValue =whirCombobox.getText('ptSupp');
    	if(ptSuppValue.length >25){
    	    $.dialog.alert(text+'不能超过最大长度25！', function(){});
    		return false;
    	}else{
    	     var regu = /['|#|&|"|?|\\|/]/g ;
    	     var re = new RegExp(regu);
    	     if (ptSuppValue.search(re) != -1){
    	     	 whir_alert(text+"不能含有字符：' # & \" ? \\ /",null,null);
    	     	 return false;
    	     }
    	}
    	
    	if((document.getElementById('detailTable').rows.length - 2) == 0){
    		$.dialog.alert('您还没有增加入库单的物品信息，请增加物品信息！', function(){});
    		return false;
    	}else{
    		var flag =true;
    		<%if(mode.equals("salesreturn")){%>
    			$('#detailTable').find('tr:not(#startTr,#endTr)').each(function(){
    				var goodsName=$(this).find('#goodsName').val();
	    			var kc       =$(this).find('#kc').val();
	    			var amount   =$(this).find('#amount').val();
	    			if(parseFloat(amount) > parseFloat(kc)){
	    				whir_alert('物品'+goodsName+'退货数量不能大于库存:'+eval(kc).toFixed(2), null, null);
	    				flag =false;
	    				return false;
	    			}
    			});
    		<%}%>
    		if(!flag){
    			return flag;
    		}
    	}
    	
        ok(0,obj);
    }
    
    function addGoods(mode,stockId){
	    if(mode == 'stock'){
	       popup({id:'intoStockForm',content:'url:<%=rootPath%>/goodsAction!list.action?addGoods=1&stockIds='+stockId+'&addcolumn=7',title:'选择物品信息',lock:true,width:950,height:450});
	    }else if(mode == 'salesreturn'){
	       popup({id:'intoStockForm',content:'url:<%=rootPath%>/goodsAction!list.action?addGoods=1&stockIds='+stockId+'&addcolumn=7&chuku=1&mode=salesreturn',title:'选择物品信息',lock:true,width:950,height:450});
	    }
	}
	
	function CheckAndCount(obj){
	    var mode ="<%=mode%>";
		//处理空格
	    $(obj).val($.trim($(obj).val()));

	    if($(obj).attr('name') == 'amount'){
	       if(isNaN($(obj).val()) || $(obj).val()<=0){
	       	   $.dialog.alert('请输入正确的数值！', function(){
	       	   	   $(obj).val('1');
	       	   	   $(obj).focus();
	       	   });
	       	   return false;
	       }else if($(obj).val() > 99999){
	       	   $.dialog.alert('数值不能大于99999！', function(){
	       	   	   $(obj).val('1');
	       	   	   $(obj).focus();
	       	   });
	       	   return false;
	       }
	    }
	    
	    if(isNaN($(obj).val()) || $(obj).val()<=0){
	        $.dialog.alert('请输入正确的数值！', function(){
	       	    $(obj).focus();
	        });
	        return false;
	    }else{
			//2014-05-27 处理小数点问题
			if($(obj).val().indexOf('.') != -1){
				var len =$(obj).val().substring($(obj).val().indexOf('.')+1,$(obj).val().length);
				if(len !=null && len !='' && len.length >2){
					$(obj).val(eval($(obj).val()).toFixed(2));
					if(isNaN($(obj).val()) || $(obj).val()<=0){
						$.dialog.alert('请输入正确的数值！', function(){
	       					$(obj).focus();
						});
						return false;
					}
				}
			}

	    	var amount = $(obj).parent().parent().find('#amount').val();
	    	var price  = $(obj).parent().parent().find('#price').val();
	    	var money  = $(obj).parent().parent().find('#money').val();
	    	var kc     = $(obj).parent().parent().find('#kc').val();
	        if($(obj).attr('name') == 'amount'){
	        	if(mode=="salesreturn" && parseFloat($(obj).val()) > parseFloat(kc)){
	        		$.dialog.alert('退货数量不能大于库存:'+eval(kc).toFixed(2), function(){
	        			$(obj).val('1');
	        			$(obj).focus();
	        		});
	        		return false;
	        	}else{
	        		var sumMoney =eval(amount*price).toFixed(2);
	        		$(obj).parent().parent().find('#money').val(sumMoney);
	        	}
	        }else if($(obj).attr('name') == 'price'){
	            var sumMoney =eval(amount*price).toFixed(2);
	            $(obj).parent().parent().find('#money').val(sumMoney);
	        }else{
	            if(mode == "stock" || mode == "salesreturn"){
	            	//var sumPrice =eval(money/amount).toFixed(2);
	            	//$(obj).parent().parent().find('#price').val(sumPrice);
					if(amount!=null&&amount!=""){
					var sumPrice =eval(money/amount).toFixed(2);
					$(obj).parent().parent().find('#price').val(sumPrice);
					}else{
					var sumPrice =eval(money/1).toFixed(2);
					$(obj).parent().parent().find('#price').val(sumPrice);
                    }					
	            }
	        }
	    }
	}
	
	function total_money(){
	    var goods_num=document.getElementById('detailTable').rows.length - 2;
	    var total_money = 0.00;
	    var cutNumber = Math.pow(10,2);
	    var total_amount = 0;
	    var total_mon = 0.00;
	    if(goods_num == 0){
	    	document.getElementById('ptMoney').value = 0;
	    }else if(goods_num==1){
	    	document.getElementById('ptMoney').value = document.getElementById('money').value;
			var amonstr=document.getElementById('amount').value;
			if(amonstr!=null&&amonstr!=""){
			total_amount += parseFloat(amonstr);
			}
			var monstr=document.getElementById('money').value;
			if(monstr!=null&&monstr!=""){
			total_mon+= eval(monstr);
			}
	    	//total_amount += parseFloat(document.getElementById('amount').value);
			//total_mon    += eval(document.getElementById('money').value);
	    }else{
	    	$('#detailTable').find('tr:not(#startTr,#endTr)').each(function(){
	    		//total_money   = total_money * 1 + $(this).find('input[name=money]').val() * 1;
				var amonstr=$(this).find('input[name=amount]').val();
			    if(amonstr!=null&&amonstr!=""){
			     total_amount += parseFloat(amonstr);
			     }
	    		//total_amount += parseFloat($(this).find('input[name=amount]').val());
				var monstr=$(this).find('input[name=money]').val();
				if(monstr!=null&&monstr!=""){
				total_money= total_money * 1 + $(this).find('input[name=money]').val() * 1;
				total_mon+= eval(monstr);
				}else{
				total_money= total_money * 1 + 0 * 1;
				}
	    		//total_mon    += eval($(this).find('input[name=money]').val());
	        });
	        document.getElementById('ptMoney').value = Math.round(total_money * cutNumber)/cutNumber;
	    }
	    document.getElementById('sum_num').value  =total_amount.toFixed(2);
	    document.getElementById('sum_money').value=total_mon.toFixed(2);
	}
</script>
</html>