ALTER DATABASE rinha set synchronous_commit=OFF;

ALTER SYSTEM SET shared_buffers TO "512MB";
ALTER SYSTEM SET effective_cache_size TO "1GB";
ALTER SYSTEM SET effective_io_concurrency = 10;
ALTER SYSTEM SET max_connections = 1000;

-- ALTER SYSTEM SET log_min_messages TO "PANIC";
-- ALTER SYSTEM SET log_min_error_statement TO "PANIC";
ALTER SYSTEM SET log_lock_waits = ON;
ALTER SYSTEM SET fsync = OFF;

CREATE TABLE IF NOT EXISTS pessoas (
    id VARCHAR(26) PRIMARY KEY NOT NULL,
    apelido VARCHAR(32) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    nascimento CHAR(10) NOT NULL,
    stack VARCHAR(1024),
    busca_trgm TEXT GENERATED ALWAYS AS (
    LOWER(nome || apelido || stack)
    ) STORED
);

CREATE EXTENSION PG_TRGM;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_pessoas_busca_trgm ON pessoas USING GIST (busca_trgm GIST_TRGM_OPS(SIGLEN=64));
