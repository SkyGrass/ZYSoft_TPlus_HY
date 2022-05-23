﻿const grid1TableConf = [
  {
    title: "ID",
    field: "ID",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 40,
    headerSort: false,
  },
  {
    title: "单号",
    field: "Code",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 180,
    headerSort: false,
  },
  {
    title: "日期",
    field: "VoucherDate",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "部门",
    field: "DeptName",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "产品编码",
    field: "InvCode",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 150,
    headerSort: false,
  },
  {
    title: "产品名称",
    field: "InvName",
    headerHozAlign: "center",
    hozAlign: "center",
    headerSort: false,
    width: 150,
  },
  {
    title: "规格型号",
    field: "InvStd",
    headerHozAlign: "center",
    hozAlign: "center",
    headerSort: false,
    width: 150,
  },
  {
    title: "总量",
    field: "quantity",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
    editor: false,
  },
  {
    title: "已入",
    field: "InQuantity",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
    editor: false,
  },
  {
    title: "未入",
    field: "UnQuantity",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
    editor: false,
  },
  {
    title: "单价",
    field: "price",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
];

const grid2TableConf = (self) => [
  {
    title: "单据ID",
    field: "FSourceBillID",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 80,
    headerSort: false,
  },
  {
    title: "单据编号",
    field: "FSourceBillNo",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 180,
    headerSort: false,
  },
  {
    title: "单据行号",
    field: "FSourceBillEntryID",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 80,
    headerSort: false,
  },
  {
    title: "产品编码",
    field: "FInvCode",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "产品名称",
    field: "FInvName",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "人员编码",
    field: "FPersonCode",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "人员名称",
    field: "FPersonName",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "单价",
    field: "FPrice",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
  {
    title: "数量",
    field: "FQuantity",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
  {
    title: "金额",
    field: "FAmount",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
];

const grid3TableConf = (self) => [
  {
    title: "人员编码",
    field: "FPersonCode",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "人员名称",
    field: "FPersonName",
    headerHozAlign: "center",
    hozAlign: "center",
    width: 120,
    headerSort: false,
  },
  {
    title: "单价",
    field: "FPrice",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
  {
    title: "数量",
    field: "FQuantity",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
    editor: "number",
    bottomCalc: "sum",
    editorParams: {
      min: 0,
      precision: 2,
      mask: "9999999999",
      selectContents: true,
      verticalNavigation: "table",
    },
    cellEdited: function (cell) {
      self.reCalc(cell);
    },
  },
  {
    title: "金额",
    field: "FAmount",
    headerHozAlign: "center",
    hozAlign: "right",
    width: 120,
    headerSort: false,
  },
];
