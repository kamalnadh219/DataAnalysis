# Stock Data Analysis and Dashboard

This repository contains the documentation and results of analyzing stock data and visualizing the findings using Power BI. The dataset includes daily stock prices and trading volumes for a specific period.


## Dataset

The dataset includes the following columns:
- **Date**: The date of the stock data.
- **Open**: The opening price of the stock.
- **High**: The highest price of the stock during the day.
- **Low**: The lowest price of the stock during the day.
- **Close**: The closing price of the stock.
- **Adj Close**: The adjusted closing price of the stock.
- **Volume**: The number of shares traded during the day.

## Data Analysis

### Data Cleaning

The dataset was cleaned to handle any missing values, convert the date column to datetime format, and set the date as the index.

### Exploratory Data Analysis

The exploratory data analysis (EDA) included calculating descriptive statistics, visualizing the distribution of closing prices, and identifying trends and patterns over time.

### Key Performance Indicators (KPIs)

The following KPIs were calculated to provide insights into the stock's performance:

1. **Average Closing Price**: Represents the average value at which the stock has been trading.
2. **Price Volatility**: Measures the variability of the stock's closing prices, indicating the level of risk.
3. **Average Daily Trading Volume**: Reflects the level of investor activity and liquidity of the stock.
4. **Quarterly Return**: Provides insights into the stock's performance over each quarter, helping to evaluate short-term trends.

## Power BI Dashboard <link> </link>

The Power BI dashboard visualizes the following KPIs:
1. **Average Closing Price**: A line chart or card visualization showing the average closing price over time.
2. **Price Volatility**: A line chart displaying the standard deviation of closing prices to indicate volatility.
3. **Average Daily Trading Volume**: A bar chart or card visualization representing the average daily trading volume.
4. **Quarterly Return**: A bar chart comparing the returns across different quarters.
