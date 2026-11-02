<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="SEEK Scraper API by Piloterr – scrape SEEK data as JSON" width="100%"></a>
</p>

# SEEK Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr SEEK Scraper API** lets you extract public data from SEEK as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **SEEK Job API** — Read one SEEK Australia job from its URL or numeric id.
- **SEEK Search API** — Search SEEK Australia jobs by keyword or by a results URL.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [SEEK Job API](#seek-job-api) | `/v2/seek/job` | 2 | Read one SEEK Australia job from its URL or numeric id. |
| [SEEK Search API](#seek-search-api) | `/v2/seek/search` | 2 | Search SEEK Australia jobs by keyword or by a results URL. |

## Table of contents

- [How it works](#how-it-works)
- [SEEK Job API](#seek-job-api)
- [SEEK Search API](#seek-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## SEEK Job API

Read one SEEK Australia job from its URL or numeric id.

`GET | POST https://api.piloterr.com/v2/seek/job` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Required. SEEK job URL or numeric id, for example 95568355 or https://www.seek.com.au/job/95568355. A keyword is rejected. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/seek/job",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "https://www.seek.com.au/job/95568355",
    },
    timeout=60,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type SeekJob = {
  id?: string;
  url?: string;
  title?: string;
  salary?: number;
  company?: string;
  currency?: string;
  location?: string;
  listed_at?: unknown;
  work_type?: string;
  salary_max?: unknown;
  salary_min?: unknown;
  description?: string;
  salary_period?: string;
  classification?: string;
  salary_display?: string;
};

const params = new URLSearchParams({
  "query": "https://www.seek.com.au/job/95568355",
});

const response = await fetch(`https://api.piloterr.com/v2/seek/job?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as SeekJob;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/seek/job
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "https://www.seek.com.au/job/95568355"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "id": "95568355",
  "url": "https://www.seek.com.au/job/95568355",
  "title": "Telehealth Nurse (RN or EN)",
  "salary": 45,
  "company": "Reorg Solutions",
  "currency": "AUD",
  "location": "Sydney NSW",
  "listed_at": null,
  "work_type": "Casual/Vacation",
  "salary_max": null,
  "salary_min": null,
  "description": "Telehealth Registered Nurse (RN) - Working With Veterans Casual Position | $45 Per Hour | Work From Home Initially Full-Time Hours | Mond…",
  "salary_period": "hour",
  "classification": "Nursing - General Medical & Surgical (Healthcare & Medical)",
  "salary_display": "$45 per hour"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `id` | string |  |
| `url` | string |  |
| `title` | string |  |
| `salary` | integer |  |
| `company` | string |  |
| `currency` | string |  |
| `location` | string |  |
| `listed_at` | object |  |
| `work_type` | string |  |
| `salary_max` | object |  |
| `salary_min` | object |  |
| `description` | string |  |
| `salary_period` | string |  |
| `classification` | string |  |
| `salary_display` | string |  |

## SEEK Search API

Search SEEK Australia jobs by keyword or by a results URL.

`GET | POST https://api.piloterr.com/v2/seek/search` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Required. Job keyword, for example nurse, or a SEEK results URL such as https://www.seek.com.au/nurse-jobs. A /job/<id> URL is rejected. |
| `page` | number | — | Optional. Page number starting at 1. Example: 2. Omitted means page 1. A page already present in a results URL is kept when this is omitted or 1. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/seek/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "nurse",
    },
    timeout=60,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type SeekSearch = {
  results?: {
    id?: string;
    url?: string;
    title?: string;
    salary?: number;
    company?: string;
    currency?: string;
    location?: string;
    listed_at?: string;
    work_type?: string;
    salary_max?: unknown;
    salary_min?: unknown;
    company_url?: string;
    salary_period?: string;
    classification?: string;
    salary_display?: string;
    subclassification?: string;
  }[];
  pagination?: {
    next?: string;
    page?: number;
    per_page?: number;
    total_pages?: unknown;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "nurse",
});

const response = await fetch(`https://api.piloterr.com/v2/seek/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as SeekSearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/seek/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "nurse"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "id": "95568355",
      "url": "https://www.seek.com.au/job/95568355",
      "title": "Telehealth Nurse (RN or EN)",
      "salary": 45,
      "company": "Reorg Solutions",
      "currency": "AUD",
      "location": "Sydney NSW",
      "listed_at": "1d ago",
      "work_type": "This is a Casual/Vacation job",
      "salary_max": null,
      "salary_min": null,
      "company_url": "https://www.seek.com.au/Reorg-Solutions-jobs",
      "salary_period": "hour",
      "classification": "Healthcare & Medical",
      "salary_display": "$45 per hour",
      "subclassification": "Nursing - General Medical & Surgical"
    }
  ],
  "pagination": {
    "next": "https://www.seek.com.au/nurse-jobs?page=2",
    "page": 1,
    "per_page": 32,
    "total_pages": null,
    "total_results": 7894
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].id` | string |  |
| `results[].url` | string |  |
| `results[].title` | string |  |
| `results[].salary` | integer |  |
| `results[].company` | string |  |
| `results[].currency` | string |  |
| `results[].location` | string |  |
| `results[].listed_at` | string |  |
| `results[].work_type` | string |  |
| `results[].salary_max` | object |  |
| `results[].salary_min` | object |  |
| `results[].company_url` | string |  |
| `results[].salary_period` | string |  |
| `results[].classification` | string |  |
| `results[].salary_display` | string |  |
| `results[].subclassification` | string |  |
| `pagination` | object |  |
| `pagination.next` | string |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | object |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Job | Search |
|---|---|---|
| cURL (Bash) | [`job`](examples/curl/job.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`job`](examples/php/job.php) | [`search`](examples/php/search.php) |
| C# | [`job`](examples/csharp/Job.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`job`](examples/go/job.go) | [`search`](examples/go/search.go) |
| Java | [`job`](examples/java/JobExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`job`](examples/ruby/job.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`job`](examples/nodejs/job.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — SEEK plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape SEEK?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/seek/job` **2**, `/v2/seek/search` **2**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the SEEK API return?

Each endpoint returns structured JSON: **SEEK Job** — `id`, `url`, `title`, `salary`, `company`, `currency`; **SEEK Search** — `results[]`, `results[].id`, `results[].url`, `results[].title`, `results[].salary`, `results[].company`.

### How do I paginate SEEK results?

Use the `page` parameter and keep requesting while the response indicates more results.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Action Scraper API](https://github.com/piloterr/action-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>SEEK is a trademark of its respective owner. This repository is not affiliated with or endorsed by SEEK. Examples are released under the MIT license.</sub>
