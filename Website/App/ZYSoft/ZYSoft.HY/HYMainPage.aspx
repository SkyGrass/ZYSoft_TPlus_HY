<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="ie=edge" />
	<title>生产上报</title>
	<!-- 引入样式 -->
	<link rel="stylesheet" href="./css/element-ui-index.css" />
	<link rel="stylesheet" href="./css/theme-chalk-index.css" />
	<link href="./css/tabulator.min.css" rel="stylesheet" />
	<link href="./js/layui/css/layui.css" rel="stylesheet" />
	<link href="./css/index.css" rel="stylesheet" />
	<link href="./css/noborder.css" rel="stylesheet" />
	<link href="./css/tool.css" rel="stylesheet" />
</head>

<body>
	<asp:Label ID="lblUserName" runat="server" Visible="false"></asp:Label>
	<asp:Label ID="lbUserId" runat="server" Visible="false"></asp:Label>
	<asp:Label ID="lbAccount" runat="server" Visible="false"></asp:Label>
	<div id="app">
		<el-container class="contain">
			<el-header id="header" style="height: inherit !important;padding:0 !important">
				<div id="toolbarContainer" class="t-page-tb" style="position: relative; z-index: 999;">
					<div id="toolbarContainer-ct" class="tb-bg">
						<ul id="toolbarContainer-gp" class="tb-group tb-first-class">
							<li tabindex="1">
								<a href=" javascript:void(0)" @click='doQuery'>
									<span class="tb-item"><span class="tb-text" title="查询">查询</span></span>
								</a>
							</li>
							<li tabindex="1">
								<a href=" javascript:void(0)" @click='doSave'>
									<span class="tb-item"><span class="tb-text" title="保存">保存</span></span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</el-header>
			<el-main>
				<el-row :gutter="5">
					<el-col style="overflow-x:auto">
						<el-form ref="form" :rules="rules" :model="form" label-width="100px" size="mini" inline>
							<table>
								<tr>
									<td>
										<el-form-item label="日期" class="form-item-max" prop='date'>
											<el-date-picker type="date" clearable style="width:100%" v-model="form.date" placeholder="请选择日期" class="noBorder">
											</el-date-picker>
										</el-form-item>
									</td>
									<td>
										<el-form-item label="部门" class="form-item-max" prop='deptId'>
											<el-input readonly style="width:100%" v-model="form.deptName" @clear='clearDept' placeholder="请选择部门" class="noBorder">
												<i class="el-icon-search" slot='suffix' @click='openDept' v-if='false'></i>
											</el-input>
										</el-form-item>
									</td>
									<td>
										<el-form-item label="仓库" class="form-item-max" prop='warehouseId'>
											<el-input clearable style="width:100%" v-model="form.warehouseName" @clear='clearWarehouse' placeholder="请选择仓库" class="noBorder">
												<i class="el-icon-search" slot='suffix' @click='openWarehouse'></i>
											</el-input>
										</el-form-item>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<el-form-item label="备注" class="form-item-full" prop='memo'>
											<el-input type="textarea" autosize row='1' clearable style="width:100%" v-model="form.memo" placeholder="请输入备注" class="noBorder">
											</el-input>
										</el-form-item>
									</td>
								</tr>
							</table>
						</el-form>
					</el-col>
				</el-row>
			</el-main>
			<el-row :gutter="1" style="padding: 0px 10px">
				<el-col :span="24">
					<el-tabs v-model="activeName" @tab-click="handleClick">
						<el-tab-pane label="日生产计划" name="tab1">
							<div id='grid1'></div>
						</el-tab-pane>
						<el-tab-pane label="暂存记录" name="tab2">
							<div id='grid2'></div>
						</el-tab-pane>
					</el-tabs>
				</el-col>
			</el-row>
		</el-container>
	</div>
	<!-- import 工具类 -->
	<script src="./js/poly/js.polyfills.js"></script>
	<script src="./js/poly/es5.polyfills.js"></script>
	<script src="./js/poly/proxy.min.js"></script>
	<script src="./js/lang.js"></script>
	<!-- import Vue before Element -->
	<script src="./js/jquery.min.js"></script>
	<script src="./js/luxon.min.js"></script>
	<script src="./js/dayjs.min.js"></script>
	<script src="./js/tableconfig.js"></script>
	<script src="./js/vue.js"></script>
	<script src="./js/element-ui-index.js"></script>
	<script src="./js/tabulator.js"></script>
	<script src="./js/math/math.min.js"></script>
	<script>
		var loginName = "<%=lblUserName.Text%>";
		var loginUserId = "<%=lbUserId.Text%>";
		var accounId = '<%=lbAccount.Text%>'
	</script>
	<script src="./js/layui/layui.js"></script>
	<script src="./js/dialog/dialog.js"></script>

	<script src="./js/rpt.js"></script>
</body>

</html>