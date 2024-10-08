﻿using DayJT.Journal.Data;

namespace DayJT.Web.API.Models
{
    public class ContentRecordModel
    {
        public int Id { get; set; }

        public string Content { get; set; } = string.Empty;

        public string ChangeNote { get; set; } = string.Empty;

        public DateTime CreatedAt { get; } = DateTime.Now;


        public int CellRefId { get; set; }
    }
}
