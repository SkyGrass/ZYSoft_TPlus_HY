var dialog = {},
  source = {};
function init(opt, record) {
  source = opt;
  var self = (dialog = new Vue({
    el: "#app",
    data: function () {
      return { rowInfo: source, grid1: {} };
    },
    methods: {
      initGrid(opt) {
        var gridId = opt.gridId,
          columns = opt.columns,
          callback = opt.callback,
          key = opt.key,
          data = opt.data;
        var maxHeight =
          $(window).height() -
          $("#toolbarContainer").height() -
          $("#rowInfo").height() -
          25;
        this[gridId] = new Tabulator("#" + gridId, {
          locale: true,
          langs: langs,
          height: maxHeight,
          columnHeaderVertAlign: "bottom",
          columns: columns,
          data: data,
          keybindings: {
            navNext: "13",
          },
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
              var newRows = rows.map(function (row) {
                row.id = opt.ID + "_" + opt.Entryid + "_" + row.code;
                row.FSourceBillID = opt.ID;
                row.FSourceBillNo = opt.Code;
                row.FSourceBillEntryID = opt.Entryid;
                row.FPersonCode = row.code;
                row.FPersonName = row.name;
                row.FInvCode = opt.InvCode;
                row.FInvName = opt.InvName;
                row.FQuantity = 0;
                row.FMatPrice = opt.FMatPrice;
                row.FPersonPrice = opt.FPersonPrice;
                row.FAmount = math.format(
                  math.multiply(
                    math.bignumber(opt.FMatPrice),
                    math.bignumber(0)
                  ),
                  14
                );
                row.FPersonAmount = math.format(
                  math.multiply(
                    math.bignumber(opt.FPersonPrice),
                    math.bignumber(0)
                  ),
                  14
                );
                return row;
              });
              self.grid1.updateOrAddData(newRows).then(function () {
                self.grid1.refreshFilter();
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
            math.bignumber(row.FMatPrice),
            math.bignumber(row.FQuantity)
          ),
          14
        );
        this.grid1.updateData([{ id: row.id, FAmount: result }]);
      },
      reCalcPerson(cell) {
        var row = cell.getData();
        var result = math.format(
          math.multiply(
            math.bignumber(row.FPersonPrice),
            math.bignumber(row.FQuantity)
          ),
          14
        );
        this.grid1.updateData([{ id: row.id, FPersonAmount: result }]);
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
    layer.msg("请先添加人员并填写数量!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else if (
    rows.some(function (f) {
      return f.FQuantity <= 0;
    })
  ) {
    layer.msg("请先正确填写数量!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else if (total > source.UnQuantity) {
    layer.msg("分配数量已经超过最大量" + source.UnQuantity + "!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  } else {
    return rows;
  }
}
