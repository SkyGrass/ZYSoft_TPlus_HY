const self = (vm = new Vue({
  el: "#app",
  data: function () {
    return {
      queryForm: {
        startDate: new Date("2022-05-01"),
        endDate: new Date(),
        deptId: "1",
        deptCode: "01",
        deptName: "总经办",
      },
      form: {
        date: new Date(),
        deptId: "1",
        warehouseId: "",
        deptCode: "",
        warehouseCode: "01",
        deptName: "总经办",
        warehouseName: "",
      },
      activeName: "tab1",
      activeName1: "tab3",
      rules: {
        date: [{ required: true, message: "日期不可为空!", trigger: "blur" }],
        deptName: [
          { required: true, message: "部门不可为空!", trigger: "blur" },
        ],
        deptId: [{ required: true, message: "部门不可为空!", trigger: "blur" }],
        warehouseName: [
          { required: true, message: "仓库不可为空!", trigger: "blur" },
        ],
        warehouseId: [
          { required: true, message: "仓库不可为空!", trigger: "blur" },
        ],
      },
      grid1: {},
      grid2: {},
      canShow: true,
      offset: {
        top: 0,
        left: 0,
      },
    };
  },
  computed: {},
  methods: {
    doQuery() {
      openDialog({
        title: "查询",
        url: "./modalFilter/ModalFilter.aspx",
        onSuccess: (layero, index, layer) => {
          layer.setTop(layero);
          self.offset.top = $(layero).offset().top - 80;
          self.offset.left = $(layero).offset().left + 40;
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          iframeWin.init({ parent: self });
        },
        onBtnYesClick: (index, layero) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var row = iframeWin.getSelect();
          if (row.length <= 0) {
            layer.msg("请先选择", { icon: 5 });
          } else if (!row) {
            layer.msg("最多只能选择一个", { icon: 5 });
          } else {
            row = row[0];
            self.queryForm.deptId = row.deptId;
            self.queryForm.deptName = row.deptName;

            self.form.deptId = row.deptId;
            self.form.deptCode = row.deptCode;
            self.form.deptName = row.deptName;

            self.queryGrid1();

            layer.close(index);
          }
        },
      });
    },
    doSave() {
      this.$refs["form"].validate((valid) => {
        if (valid) {
          var rows = self.grid2.getData();
          if (rows.length <= 0) {
            return layer.msg("未发现需要提交的暂存记录!", { icon: 5 });
          }

          var postForm = {
            Token: "",
            FDate: dayjs(self.form.date).format("YYYY-MM-DD"),
            FDeptCode: self.form.deptCode,
            FWhCode: self.form.warehouseCode,
            FMemo: self.form.memo,
            Entry: rows.map((m) => {
              return {
                FInvCode: m.FInvCode,
                FBatch: "",
                FQuantity: m.FQuantity,
                FNum: "0",
                FProductionDate: "",
                FExpiryDate: "",
                FPrice: m.FPrice,
                FAmount: m.FAmount,
                FSourceBillID: m.FSourceBillID,
                FSourceBillEntryID: m.FSourceBillEntryID,
                FSourceBillNo: m.FSourceBillNo,
                FPersonName: m.FPersonName,
              };
            }),
          };
          layer.confirm(
            "确定要上报记录吗?",
            { icon: 3, title: "提示" },
            (index) => {
              var _index = layer.load(2);
              $.ajax({
                type: "POST",
                url: "./HYHandler.ashx",
                async: true,
                data: {
                  SelectApi: "save",
                  formStr: JSON.stringify(postForm),
                },
                dataType: "json",
                success: function (result) {
                  if (result.state == "success") {
                  }
                  layer.msg(result.msg, { icon: 5 });
                  layer.close(_index);
                },
                error: function () {
                  layer.close(_index);
                  layer.msg("上报信息出错!", { icon: 5 });
                },
              });
            }
          );
        } else {
          return false;
        }
      });
    },
    openBaseDataDialog(type, title, success) {
      openDialog({
        title: title,
        url: "./modal/Dialog.aspx",
        offset: [self.offset.top, self.offset.left],
        onSuccess: (layero, index, layer) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          iframeWin.init({ dialogType: type });
        },
        onBtnYesClick: (index, layero) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var row = iframeWin.getSelect();
          if (row.length <= 0) {
            layer.msg("请先选择", { icon: 5 });
          } else if (!row) {
            layer.msg("最多只能选择一个", { icon: 5 });
          } else {
            success && success(row);
            layer.close(index);
          }
        },
      });
    },
    openDept() {
      openDialog({
        title: "仓库",
        url: "./modal/Dialog.aspx",
        onSuccess: (layero, index, layer) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          iframeWin.init({ layer, dialogType: "dept" });
        },
        onBtnYesClick: (index, layero) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var row = iframeWin.getSelect();
          if (row.length <= 0) {
            layer.msg("请先选择", { icon: 5 });
          } else if (!row) {
            layer.msg("最多只能选择一个", { icon: 5 });
          } else {
            row = row[0];
            self.form.deptId = row.id;
            self.form.deptName = row.name;
            layer.close(index);
          }
        },
      });
    },
    openWarehouse() {
      openDialog({
        title: "仓库",
        url: "./modal/Dialog.aspx",
        onSuccess: (layero, index, layer) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          iframeWin.init({ layer, dialogType: "warehouse" });
        },
        onBtnYesClick: (index, layero, layer) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var row = iframeWin.getSelect();
          if (row.length <= 0) {
            layer.msg("请先选择", { icon: 5 });
          } else if (!row) {
            layer.msg("最多只能选择一个", { icon: 5 });
          } else {
            row = row[0];
            self.form.warehouseId = row.id;
            self.form.warehouseName = row.name;
            layer.close(index);
          }
        },
      });
    },
    initGrid({ gridId, columns, callback, key }) {
      var maxHeight =
        $(window).height() -
        $("#header").height() -
        $("#toolbarContainer").height() -
        125;
      this[gridId] = new Tabulator("#" + gridId, {
        locale: true,
        langs: langs,
        height: maxHeight,
        columnHeaderVertAlign: "bottom",
        columns: columns,
        key: key,
        data: [],
        ajaxResponse: function (url, params, response) {
          if (response.state == "success") {
            let t = response.data.map((m, i) => {
              m.VoucherDate = dayjs(m.VoucherDate).format("YYYY-MM-DD");
              m.rid = i + 1;
              return m;
            });

            return t;
          } else {
            layer.msg("没有查询到数据", { icon: 5 });
            return [];
          }
        },
      });

      this[gridId].on("tableBuilt", () => {
        callback && callback(this[gridId]);
      });
    },
    handleClick(tab, event) {
      this.canShow = this.activeName == "tab1";
    },
    queryGrid1() {
      var index = layer.load(2);
      setTimeout(() => {
        self.grid1.clearData();
        self.grid1.setData(
          "./HYHandler.ashx",
          Object.assign(
            {
              SelectApi: "getPlanList",
            },
            self.queryForm
          ),
          "POST"
        );
        layer.close(index);
      }, 500);
    },
    onClickDetail(item) {
      openDialog({
        title: "明细记录",
        url: "./HYDetailPage.aspx?v=" + new Date() * 1,
        area: [$(window).width() - 100 + "px", $(window).height() - 100 + "px"],
        onSuccess: (layero, index, layer) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var _cache = self.grid2.getData();
          _cache = _cache.filter(
            (f) =>
              (f.FSouceBillID == item.ID ||
                f.FSouceBillID == item.FSouceBillID) &&
              (f.FSourceBillEntryID == item.Entryid ||
                f.FSourceBillEntryID == item.FSourceBillEntryID)
          );
          iframeWin.init(item, _cache);
        },
        onBtnYesClick: (index, layero) => {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var rows = iframeWin.getSelect();
          if (rows.length > 0) {
            self.activeName = "tab2";
            rows.forEach((row) => {
              self.grid2.updateOrAddData(
                [row].map((m) => {
                  m.id =
                    row.FSouceBillID +
                    "_" +
                    row.FSourceBillEntryID +
                    "_" +
                    row.FPersonCode;
                  return m;
                })
              );
            });
            layer.close(index);
          }
        },
      });
    },
    clearDept() {
      this.form.deptId = "";
    },
    clearWarehouse() {
      this.form.warehouseId = "";
    },
  },
  mounted() {
    this.initGrid({
      gridId: "grid1",
      key: "ID",
      columns: [
        {
          formatter: function (cell, formatterParams, onRendered) {
            return "<i class='el-icon-tickets'></i>";
          },
          width: 80,
          title: "详情",
          headerHozAlign: "center",
          hozAlign: "center",
          headerSort: false,
          cellClick: function (e, cell) {
            self.onClickDetail(cell.getRow().getData());
          },
        },
      ].concat(grid1TableConf),
    });
    this.initGrid({
      gridId: "grid2",
      columns: [
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
            const r = cell.getRow();
            r.delete();
          },
        },
      ]
        .concat(grid2TableConf(this))
        .concat([
          {
            formatter: function (cell, formatterParams, onRendered) {
              return "<i class='el-icon-tickets'></i>";
            },
            width: 80,
            title: "详情",
            headerHozAlign: "center",
            hozAlign: "center",
            headerSort: false,
            cellClick: function (e, cell) {
              self.onClickDetail(cell.getRow().getData());
            },
          },
        ]),
      key: "id",
    });
    window.onresize = function () {
      self.grid1.setHeight(
        $(window).height() -
          $("#header").height() -
          $("#toolbarContainer").height() -
          125
      );
      self.grid2.setHeight(
        $(window).height() -
          $("#header").height() -
          $("#toolbarContainer").height() -
          125
      );
    };

    this.doQuery();
  },
}));
