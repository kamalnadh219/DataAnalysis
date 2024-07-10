# Stock Data Analysis and Dashboard

This repository contains the code and documentation for analyzing stock data and visualizing the results using Power BI. The dataset includes daily stock prices and trading volumes for a specific period.

## Table of Contents
- [Dataset](#dataset)
- [Data Analysis](#data-analysis)
  - [Data Cleaning](#data-cleaning)
  - [Exploratory Data Analysis](#exploratory-data-analysis)
  - [Key Performance Indicators (KPIs)](#key-performance-indicators-kpis)
- [Power BI Dashboard](#power-bi-dashboard)
- [How to Run](#how-to-run)
- [License](#license)

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

1. **Load the dataset**:
    ```python
    import pandas as pd
    df = pd.read_csv('stock_data.csv')
    ```

2. **Handle missing values**:
    ```python
    df.dropna(inplace=True)
    ```

3. **Convert date column to datetime**:
    ```python
    df['Date'] = pd.to_datetime(df['Date'])
    df.set_index('Date', inplace=True)
    ```

### Exploratory Data Analysis

1. **Descriptive statistics**:
    ```python
    df.describe()
    ```

2. **Distribution of closing prices**:
    ```python
    import matplotlib.pyplot as plt
    import seaborn as sns

    sns.histplot(df['Close'], kde=True)
    plt.title('Distribution of Closing Prices')
    plt.show()
    ```

### Key Performance Indicators (KPIs)

1. **Average Closing Price**:
    ```python
    average_closing_price = df['Close'].mean()
    print(f"Average Closing Price: {average_closing_price:.2f}")
    ```

2. **Price Volatility (Standard Deviation of Closing Prices)**:
    ```python
    price_volatility = df['Close'].std()
    print(f"Price Volatility: {price_volatility:.2f}")
    ```

3. **Average Daily Trading Volume**:
    ```python
    average_daily_volume = df['Volume'].mean()
    print(f"Average Daily Trading Volume: {average_daily_volume:.2f}")
    ```

4. **Quarterly Return**:
    ```python
    df['Quarter'] = df.index.to_period('Q')
    quarterly_return = df.groupby('Quarter')['Close'].apply(lambda x: (x.iloc[-1] - x.iloc[0]) / x.iloc[0] * 100)
    print(f"Quarterly Return:\n{quarterly_return}")
    ```
