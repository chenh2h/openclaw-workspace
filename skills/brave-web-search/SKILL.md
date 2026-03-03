---
name: brave-web-search
description: Web search using Brave Search API. Use when the user needs to search the web for current information, news, documentation, or any online content. Falls back to web_fetch for extracting content from specific URLs.
allowed-tools: web_search, web_fetch
---

# Brave Web Search

Search the web using Brave Search API (built into OpenClaw).

## When to Use

- Finding current information
- Searching documentation
- Looking up news and updates
- Researching topics
- Finding free resources

## Usage

### Search

```javascript
// Search the web
web_search({
  query: "OpenClaw latest release",
  count: 5
})
```

### Fetch Specific URL

```javascript
// Extract content from a URL
web_fetch({
  url: "https://github.com/openclaw/openclaw/releases",
  extractMode: "markdown"
})
```

### Parameters

**web_search:**
- `query` (required): Search query string
- `count` (optional): Number of results (1-10, default 5)
- `country` (optional): 2-letter country code for region-specific results
- `search_lang` (optional): Language code for search results
- `freshness` (optional): Filter by discovery time (pd, pw, pm, py)

**web_fetch:**
- `url` (required): HTTP or HTTPS URL to fetch
- `extractMode` (optional): "markdown" or "text" (default: markdown)
- `maxChars` (optional): Maximum characters to return

## Examples

### Search for Free LLM APIs

```javascript
web_search({
  query: "free LLM API OpenRouter Groq",
  count: 10
})
```

### Get Latest Release Info

```javascript
web_search({
  query: "OpenClaw v2026.3.2 release",
  freshness: "pd"  // past day
})
```

### Fetch Documentation

```javascript
web_fetch({
  url: "https://docs.openclaw.ai",
  maxChars: 5000
})
```

## Rate Limits

- Depends on OpenClaw's Brave Search API key configuration
- Contact admin if search fails

## Notes

- This is a wrapper skill for OpenClaw's built-in web_search tool
- Requires `BRAVE_API_KEY` to be configured in OpenClaw gateway
- If search fails, try web_fetch on specific known URLs
