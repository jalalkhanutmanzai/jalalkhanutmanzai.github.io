"""Check the built public site, without making external requests."""
import json
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path("_site").resolve()
errors = []
documents = {}

class Document(HTMLParser):
    def __init__(self, file):
        super().__init__(convert_charrefs=True)
        self.file = file
        self.ids = set()
        self.links = []
        self.titles = 0
        self.descriptions = 0
        self.canonicals = []
        self.json_text = None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if attrs.get("id"):
            self.ids.add(attrs["id"])
        if tag == "title":
            self.titles += 1
        if tag == "meta" and attrs.get("name") == "description":
            self.descriptions += 1
            if not attrs.get("content"):
                errors.append(f"{self.file}: empty description")
        if tag == "link" and attrs.get("rel") == "canonical":
            self.canonicals.append(attrs.get("href", ""))
        if tag == "img" and "alt" not in attrs:
            errors.append(f"{self.file}: image missing alt")
        for attribute in ("href", "src"):
            if attrs.get(attribute):
                self.links.append(attrs[attribute])
        if tag == "script" and attrs.get("type") == "application/ld+json":
            self.json_text = ""

    def handle_data(self, data):
        if self.json_text is not None:
            self.json_text += data

    def handle_endtag(self, tag):
        if tag == "script" and self.json_text is not None:
            try:
                json.loads(self.json_text)
            except ValueError:
                errors.append(f"{self.file}: invalid structured data")
            self.json_text = None

for file in ROOT.rglob("*.html"):
    doc = Document(file.relative_to(ROOT))
    doc.feed(file.read_text(encoding="utf-8"))
    documents[file] = doc
    if doc.titles != 1 or doc.descriptions != 1 or len(doc.canonicals) != 1:
        errors.append(f"{doc.file}: duplicate or missing SEO title/description/canonical")
    if doc.canonicals and not doc.canonicals[0].startswith("https://jalalkhan.me/"):
        errors.append(f"{doc.file}: incorrect canonical")

for file, doc in documents.items():
    for link in doc.links:
        parsed = urlsplit(link)
        if parsed.scheme not in ("", "http", "https") or parsed.netloc not in ("", "jalalkhan.me"):
            continue
        target = ROOT / unquote(parsed.path).lstrip("/") if parsed.path.startswith("/") else file.parent / unquote(parsed.path)
        target = target.resolve()
        if target.is_dir():
            target /= "index.html"
        if not target.is_file():
            errors.append(f"{doc.file}: broken internal link {link}")
        elif parsed.fragment and target in documents and unquote(parsed.fragment) not in documents[target].ids:
            errors.append(f"{doc.file}: missing anchor {link}")

home = (ROOT / "index.html").read_text(encoding="utf-8")
for expected in ("https://www.fiverr.com/jalalkhan326", "October 2026"):
    if expected not in home:
        errors.append(f"Homepage missing {expected}")
for required in ("robots.txt", "sitemap.xml", "404.html"):
    if not (ROOT / required).is_file():
        errors.append(f"Missing {required}")
if not documents:
    errors.append("No built HTML pages found")
if errors:
    raise SystemExit("\n".join(errors))
print(f"Passed: {len(documents)} pages; metadata, structured data, local links, images, Fiverr, graduation date, and discovery files.")
