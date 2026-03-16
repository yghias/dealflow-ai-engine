# API Integrations

## Source Systems
- Company/funding feed API
- News API
- Hiring trend API
- Investor directory export
- Public filing and transcript source
- Salesforce extracts
- Email engagement logs
- Web scraping for company sites

## Example External Contract
```json
{
  "source_record_id": "sig_001",
  "event_type": "funding_announcement",
  "company_name": "North Ridge Systems",
  "headline": "North Ridge Systems raises Series B",
  "event_timestamp": "2026-03-16T10:30:00Z",
  "url": "https://example.com/funding",
  "investors": ["Summit Peak Ventures"]
}
```

## Internal API Shapes
- health endpoint
- signal ingest trigger
- strategy generation trigger
- CRM dispatch trigger
- backfill trigger
