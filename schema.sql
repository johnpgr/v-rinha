CREATE TABLE IF NOT EXISTS pessoas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    apelido VARCHAR(32) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    nascimento CHAR(10) NOT NULL,
    stack TEXT NOT NULL,
    search TEXT GENERATED ALWAYS AS (
    LOWER(nome || apelido || stack)
    ) STORED
);

CREATE EXTENSION PG_TRGM;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_pessoas_search ON pessoas USING GIST (search GIST_TRGM_OPS(SIGLEN=64));
