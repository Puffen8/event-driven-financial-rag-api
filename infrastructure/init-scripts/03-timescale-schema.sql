CREATE TABLE stocks (
    ticker VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE, -- For the ability to pause the ingestion of a specific stock without deleting its data
    added_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE daily_stock_data (
    ticker VARCHAR(10) REFERENCES supported_stocks(ticker) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    open NUMERIC(10, 4),
    high NUMERIC(10, 4),
    low NUMERIC(10, 4),
    close NUMERIC(10, 4),
    volume BIGINT,
    UNIQUE (ticker, timestamp)
);
SELECT create_hypertable('stock_data', 'timestamp');
CREATE INDEX idx_stock_data_ticker_time ON stock_data (ticker, timestamp DESC);

CREATE TABLE stock_fundamental_metrics (
    ticker VARCHAR(10) REFERENCES supported_stocks(ticker) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    pe_ratio NUMERIC(10, 4),
    ps_ratio NUMERIC(10, 4),
    dividend_yield NUMERIC(5, 4),
    UNIQUE (ticker, timestamp)
);
SELECT create_hypertable('stock_fundamental_metrics', 'timestamp');
CREATE INDEX idx_fundamentals_ticker_time ON stock_fundamental_metrics (ticker, timestamp DESC);


