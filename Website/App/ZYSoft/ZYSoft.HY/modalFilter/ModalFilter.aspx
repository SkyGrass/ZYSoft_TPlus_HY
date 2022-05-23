﻿<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="ie=edge" />
	<link rel="stylesheet" href="../css/element-ui-index.css" />
	<link rel="stylesheet" href="../css/theme-chalk-index.css" />
	<link href="../css/tabulator.min.css" rel="stylesheet" />
	<link href="./dialogFilter.css" rel="stylesheet" />
	<link href="../css/noborder.css" rel="stylesheet" />
</head>

<body>
	<div id="app">
		<el-row>
			<el-col :push="1" :span="20" :pull="1">
				<el-form ref="form" :model="form" label-width="100px" size="mini" inline>
					<table>
						<tr>
							<td>
								<el-form-item label="开始日期" class="form-item-max" prop='startDate'>
									<el-date-picker type="date" clearable style="width:100%" v-model="form.startDate" placeholder="请选择开始日期" class="noBorder"></el-date-picker>
								</el-form-item>
							</td>
							<td>
								<el-form-item label="结束日期" class="form-item-max" prop='endDate'>
									<el-date-picker type="date" clearable style="width:100%" v-model="form.endDate" placeholder="请选择结束日期" class="noBorder"></el-date-picker>
								</el-form-item>
							</td>
						</tr>
						<tr>
							<td>
								<el-form-item label="部门" class="form-item-max" prop='deptName'>
									<el-input clearable @clear='onClearDept' style="width:100%" v-model="form.deptName" placeholder="请选择部门" class="noBorder">
										<i class="el-icon-search" slot='suffix' @click='openDept'></i>
									</el-input>
								</el-form-item>
							</td>
						</tr>
					</table>
				</el-form>
			</el-col>
		</el-row>
	</div>
	<!-- import Vue before Element -->
	<script src="../js/jquery.min.js"></script>
	<script src="../js/vue.js"></script>
	<script src="../js/element-ui-index.js"></script>
	<script src="../js/tabulator.js"></script>
	<script src="../js/layui/layui.js"></script>
	<script src="../js/dayjs.min.js"></script>
	<script src="./dialogFilter.js"></script>
	<script src="../js/math/math.min.js"></script>
</body>

</html>