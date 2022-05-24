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
                                <a href=" javascript:void(0)" @click='doAddPerson'>
                                    <span class="tb-item"><span class="tb-text" title="添加人员">添加人员</span></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </el-header>
            <el-main>
                <el-row :gutter="1" style="padding: 0px 10px 5px 10px" id='rowInfo'>
                    <el-col :span="24">
                        <table border="1" style="width: 100%;text-align:center;border: 1px solid #999;">
                            <tr style="background-color:#e6e6e6; color: #555;font-weight: 700;">
                                <td style="padding:5px">产品编码</td>
                                <td>产品名称</td>
                                <td>规格型号</td>
                                <td>总量</td>
                                <td>已入</td>
                                <td>未入</td>
                                <td>单价</td>
                                <td>人工单价</td>
                            </tr>
                            <tr>
                                <td style="padding:5px">{{rowInfo.InvCode}}</td>
                                <td>{{rowInfo.InvName}}</td>
                                <td>{{rowInfo.InvStd}}</td>
                                <td>{{rowInfo.quantity}}</td>
                                <td>{{rowInfo.InQuantity}}</td>
                                <td>{{rowInfo.UnQuantity}}</td>
                                <td>{{rowInfo.FMatPrice}}</td>
                                <td>{{rowInfo.FPersonPrice}}</td>
                            </tr>
                        </table>
                    </el-col>
                </el-row>
                <el-row :gutter="1" style="padding: 0px 10px">
                    <el-col :span="24">
                        <div id='grid1'></div>
                    </el-col>
                </el-row>
            </el-main>
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

    <script src="./js/dialog/dialog.js"></script>
    <script src="./js/layui/layui.js"></script>

    <script src="./js/rptdetail.js"></script>
</body>

</html>