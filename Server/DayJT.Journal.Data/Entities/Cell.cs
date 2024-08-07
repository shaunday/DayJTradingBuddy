﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DayJT.Journal.Data
{
    public class Cell
    {
        [Key]
        public Guid Id { get; private set; } = Guid.NewGuid();

        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public ComponentType ComponentType { get; set; }

        #region Content

        public CellContent ContentWrapper { get; set; }

        public string Content
        {
            get { return ContentWrapper.Content; }
            set
            {
                ContentWrapper = new CellContent
                {
                    Content = value
                };
            }
        }

        #endregion

        #region flags

        [MaxLength(50)]
        public ValueRelevance CostRelevance { get; set; } = ValueRelevance.None;

        [MaxLength(50)]
        public ValueRelevance PriceRelevance { get; set; } = ValueRelevance.None;

        public bool IsRelevantForOverview { get; set; } = false;

        #endregion

        public CellType CellType { get; private set; }

        public ICollection<CellContent> History { get; set; } = new List<CellContent>();

        public Cell(CellType cellType, string title)
        {
            Title = title;
            CellType = cellType;
        }

        //parent
        public Guid TradeComponentRefId { get; set; }

        public TradeComponent TradeComponentRef { get; set; } = null!; // Required reference navigation to principal

    }

}
