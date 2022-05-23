var dialog = {},
  source = {};
function init(opt, record) {
  source = opt;
  var self = (dialog = new Vue({
    el: "#app",
    data: function () {
      return { list: [], grid1: {} };
    },
    methods: {
      initGrid(opt) {
        var gridId = opt.gridId,
          columns = opt.columns,
          callback = opt.callback,
          key = opt.key,
          data = opt.data;
        var maxHeight =
          $(window).height() - $("#toolbarContainer").height() - 20;
        this[gridId] = new Tabulator("#" + gridId, {
          locale: true,
          langs: langs,
          height: maxHeight,
          columnHeaderVertAlign: "bottom",
          columns: columns,
          data: data,
        });
      },
      doAddPerson() {
        openDialog({
          title: "选取人员",
          url: "./modal/Dialog.aspx",
          selectable: true,
          onSuccess: function (layero, index, layer) {
            var iframeWin = window[layero.find("iframe")[0]["name"]];
            iframeWin.init({
              dialogType: "person",
              extend: { deptId: opt.iddepartment },
            });
          },
          onBtnYesClick: function (index, layero, layer) {
            var iframeWin = window[layero.find("iframe")[0]["name"]];
            var rows = iframeWin.getSelect();
            if (rows != void 0 && rows.length > 0) {
              rows.forEach(function (row) {
                var exist = self.list.filter(function (f) {
                  return f.FPersonCode == row.code;
                });
                if (exist.length <= 0) {
                  self.grid1.updateOrAddData([
                    {
                      id: row.id,
                      FSourceBillID: opt.ID,
                      FSourceBillNo: opt.Code,
                      FSourceBillEntryID: opt.Entryid,
                      FPersonCode: row.code,
                      FPersonName: row.name,
                      FInvCode: opt.InvCode,
                      FInvName: opt.InvName,
                      FQuantity: 0,
                      FPrice: 1, //opt.Price,
                      FAmount: math.format(
                        math.multiply(
                          math.bignumber(opt.Price),
                          math.bignumber(0)
                        ),
                        14
                      ),
                    },
                  ]);
                }
              });
              layer.close(index);
            }
          },
        });
      },
      onDelRow(cell, row) {
        var r = cell.getRow();
        r.delete();
      },
      reCalc(cell) {
        var row = cell.getData();
        var result = math.format(
          math.multiply(
            math.bignumber(row.FPrice),
            math.bignumber(row.FQuantity)
          ),
          14
        );
        this.grid1.updateData([{ id: row.id, FAmount: result }]);
      },
    },
    mounted() {
      var _self = this;
      this.initGrid({
        gridId: "grid1",
        columns: grid3TableConf(this).concat([
          {
            formatter: function (cell, formatterParams, onRendered) {
              return "<i class='el-icon-delete'></i>";
            },
            width: 80,
            title: "删除",
            headerHozAlign: "center",
            hozAlign: "center",
            headerSort: false,
            cellClick: function (e, cell) {
              _self.onDelRow(cell, cell.getRow().getData());
            },
          },
        ]),
        data: record,
      });
    },
  }));
}

function getSelect() {
  var rows = dialog.grid1.getData();
  var total = rows.reduce(function (total, ele) {
    return total + ele.FQuantity;
  }, 0);
  if (rows.length <= 0) {
    top.layer.msg("请先添加人员并填写数量!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else if (
    rows.some(function (f) {
      return f.FAmount <= 0;
    })
  ) {
    top.layer.msg("请先正确填写数量!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else if (total > source.UnQuantity) {
    top.layer.msg("分配数量已经超过最大量" + source.UnQuantity + "!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else {
    return rows;
  }
}
