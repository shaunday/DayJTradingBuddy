﻿using DayJT.Journal.Data;

namespace DayJT.Web.API.Models
{
    public class TradeComponentModel
    {
        public Guid Id { get; set; }
        public TradeActionType TradeActionType { get; set; }
        public List<CellModel>? TradeActionInfoCells { get; set; }
    }
}
