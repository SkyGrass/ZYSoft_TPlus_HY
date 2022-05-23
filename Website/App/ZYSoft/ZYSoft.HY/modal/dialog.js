var dialog = {};
function init(opt) {
  const self = (dialog = new Vue({
    el: "#app",
    data() {
      return {
        queryForm: { keyword: "" },
        columns: opt.columns,
        tableData: opt.tableData,
        url: "",
        detail: "",
        grid: {},
      };
    },
    methods: {
      initConfig() {
        $.ajax({
          type: "POST",
          url: "../HYHandler.ashx",
          async: true,
          data: {
            SelectApi: "getDialogConf",
            dialogType: opt.dialogType,
          },
          dataType: "json",
          success: function (result) {
            if (result.state == "success") {
              result = result.data;
              self.url = result.url;
              self.grid = new Tabulator("#table", {
                locale: true,
                langs: {
                  "zh-cn": {
                    data: {
                      loading: "加载中", //data loader text
                      error: "错误", //data error text
                    },
                  },
                },
                index: result.key,
                columnHeaderVertAlign: "bottom",
                height: 245,
                selectable: result.selectable || 1,
                columns: [
                  {
                    title: "勾选",
                    formatter: "rowSelection",
                    titleFormatter: "rowSelection",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    headerSort: false,
                    frozen: true,
                    cellClick: function (e, cell) {
                      cell.getRow().toggleSelect();
                    },
                  },
                ].concat(result.columns),
                ajaxURL: self.url,
                ajaxConfig: "POST",
                ajaxParams: Object.assign(
                  { SelectApi: result.method },
                  self.form,
                  opt.extend
                ),
                ajaxResponse: function (url, params, response) {
                  if (response.state == "success") {
                    return response.data.map(function (m, i) {
                      m.rid = i + 1;
                      return m;
                    });
                  } else {
                    top.layer.msg("没有查询到数据", { icon: 5 });
                    return [];
                  }
                },
              });
            } else {
              top.layer.msg(result.msg, { icon: 5 });
            }
          },
          error: function () {
            top.layer.msg("查询配置信息出错!", { icon: 5 });
          },
        });
      },
      clearFilter() {
        this.grid.clearFilter();
      },
      doFilter() {
        this.grid.setFilter([
          [
            { field: "code", type: "like", value: this.queryForm.keyword },
            { field: "name", type: "like", value: this.queryForm.keyword },
          ],
        ]);
      },
    },
    watch: {},
    mounted() {
      this.initConfig();
    },
  }));
}

function getSelect() {
  var rows = dialog.grid.getSelectedData();
  if (rows != void 0 && rows.length <= 0) {
    top.layer.msg("尚未选择数据！", { zIndex: new Date() * 1, icon: 5 });
    return [];
  } else {
    return rows;
  }
}
