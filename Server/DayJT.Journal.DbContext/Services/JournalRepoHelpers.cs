﻿using DayJT.Journal.Data;
using DayJTrading.Journal.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DayJT.Journal.DataContext.Services
{
    internal static class JournalRepoHelpers
    {
        internal static (double totalCost, double totalAmount, double profit) GetAvgEntryAndProfit(TradeComposite trade)
        {
            List<(double priceValue, double cost)> entriesWithAmount = new();
            double profit = 0.0;

            var interims = trade.TradeElements
                .Where(t => t.TradeActionType == TradeActionType.AddPosition || t.TradeActionType == TradeActionType.ReducePosition)
                .ToList();

            foreach (var tradeInput in interims)
            {
                double cost = 0.0;
                double priceValue = 0.0;
                foreach (var component in tradeInput.Entries)
                {
                    if (component.CostRelevance == ValueRelevance.Add || component.CostRelevance == ValueRelevance.Substract)
                    {
                        double.TryParse(component.Content, out cost);

                        if (component.CostRelevance == ValueRelevance.Add)
                        {
                            profit += cost;
                        }

                        else if (component.CostRelevance == ValueRelevance.Substract)
                        {
                            profit -= cost;
                        }
                    }

                    if (component.PriceRelevance == ValueRelevance.Add || component.PriceRelevance == ValueRelevance.Substract)
                    {
                        double.TryParse(component.Content, out priceValue);
                        if (component.PriceRelevance == ValueRelevance.Substract)
                        {
                            priceValue *= -1;
                        }
                    }
                }

                //should have both change and price now
                if (cost > 0 && priceValue > 0)
                {
                    entriesWithAmount.Add((priceValue, cost));
                }
            }


            double totalAmount = 0.0;
            double totalCost = 0.0;

            foreach (var item in entriesWithAmount)
            {
                //will substract if exit trade
                totalCost += item.cost * item.priceValue;
                totalAmount += item.cost / item.priceValue;
            }

            return (totalCost, totalAmount, profit);
        }

        internal static TradeElement CreateTradeElementForClosure(TradeComposite trade, string closingPrice, (double totalCost, double totalAmount, double profit) analytics)
        {
            // Create a TradeElement for ReducePosition
            var tradeInput = new TradeElement(trade, TradeActionType.ReducePosition);

            // Find price entry
            var priceEntry = tradeInput.Entries.SingleOrDefault(ti => ti.PriceRelevance == ValueRelevance.Substract);
            if (priceEntry == null)
            {
                throw new InvalidOperationException("Could not find price entry to reduce / close position");
            }
            priceEntry.Content = closingPrice;

            // Find cost entry
            var costEntry = tradeInput.Entries.SingleOrDefault(ti => ti.CostRelevance == ValueRelevance.Substract);
            if (costEntry == null)
            {
                throw new InvalidOperationException("Could not find cost entry to reduce / close position");
            }

            if (double.TryParse(closingPrice, out double closingPriceValue))
            {
                costEntry.Content = (closingPriceValue * analytics.totalAmount).ToString();
            }
            else
            {
                throw new FormatException("Could not parse closing price");
            }

            // Create TradeElement for Closure
            var tradeClosure = new TradeElement(trade, TradeActionType.Closure);
            tradeClosure.Entries = SummaryPositionsFactory.GetTradeClosureComponents(tradeClosure, profitValue: analytics.profit.ToString());

            return tradeInput; // Return tradeInput, as this is the entry we are adding
        }

        internal static TradeElement GetInterimSummary(TradeComposite trade)
        {
            var analytics = GetAvgEntryAndProfit(trade);

            string averageEntry = string.Empty, totalAmount = string.Empty, totalCost = string.Empty;
            if (analytics.totalCost > 0)
            {
                totalCost = analytics.totalCost.ToString();

                if (analytics.totalAmount > 0)
                {
                    totalAmount = analytics.totalAmount.ToString();
                    averageEntry = (analytics.totalCost / analytics.totalAmount).ToString();
                }
            }

            TradeElement summary = new TradeElement(trade, TradeActionType.InterimSummary);
            summary.Entries = SummaryPositionsFactory.GetSummaryComponents(summary, averageEntry, totalAmount, totalCost);

            return summary;
        }

        internal static void RemoveInterimInput(ref TradeComposite trade, string tradeInputId)
        {
            var tradeInputToRemove = trade.TradeElements.Where(t => t.Id.ToString() == tradeInputId).SingleOrDefault();

            if (tradeInputToRemove != null && (tradeInputToRemove.TradeActionType == TradeActionType.ReducePosition || tradeInputToRemove.TradeActionType == TradeActionType.ReducePosition))
            {
                trade.TradeElements.Remove(tradeInputToRemove);
            }
            else
            {
                throw new Exception("weird");
            }
        }
    }
}
