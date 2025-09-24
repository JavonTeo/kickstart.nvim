import scrapy
from scrapy.crawler import CrawlerProcess


class ACLSpider(scrapy.Spider):
    name = "ACLSpider"

    def __init__(self, **kwargs):
        arguments = kwargs.get("arguments")
        self.links_file = arguments[0]
        self.start_index = arguments[1]
        self.end_index = arguments[2]

    def start_requests(self):
        with open(self.links_file, "r") as file:
            lines = file.readlines()

        lines_to_scrape = lines[self.start_index : self.end_index]
        for line in lines_to_scrape:
            url = line.replace(".pdf", "/")
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        main_metadata = response.css("#main")

        dl_metadata = main_metadata.css("dl")
        dt_elements = dl_metadata.css("dt::text").getall()
        # Get all dd elements
        dd_elements = []
        for dd in dl_metadata.css("dd"):
            # Join all text parts inside the current <dd>
            text_parts = dd.css("::text, a::text").getall()  # Get all text parts
            joined_text = "".join(text_parts)  # Join them with a comma and space
            dd_elements.append(joined_text)
        dt_dd_dict = {}
        # Create a dictionary to hold the dt-dd pairs
        for dt, dd in zip(dt_elements, dd_elements):
            dt_dd_dict[dt[:-1].strip()] = dd.strip()

        def check_empty(field):
            # returns an empty string if field is None
            return field or ""

        yield {
            "acl_id": check_empty(dt_dd_dict["Anthology ID"]),
            "title": "".join(
                check_empty(main_metadata.css("#title a *::text").getall())
            ).strip(),
            "author": ",".join(
                check_empty(main_metadata.css("p.lead a::text").getall())
            ),
            "abstract": "".join(
                check_empty(
                    main_metadata.css("div.card-body.acl-abstract span::text").get()
                )
            ),
            "url": check_empty(dt_dd_dict["URL"]),
            "year": check_empty(dt_dd_dict["Year"]),
            "month": check_empty(dt_dd_dict["Month"]),
            # 'booktitle': metadata.css(),
            "pages": check_empty(dt_dd_dict["Pages"]),
            "address": check_empty(dt_dd_dict["Address"]),
            "doi": check_empty(dt_dd_dict["DOI"]),
            # 'journal': metadata.css(),
            "volume": check_empty(dt_dd_dict["Volume"]),
            # 'number': metadata.css(),
            "editor": check_empty(dt_dd_dict["Editors"].replace("\n", "")),
            # 'isbn': metadata.css(),
            # 'ENTITYTYPE': metadata.css(),
            "bib_key": check_empty(dt_dd_dict["Bibkey"]),
            "note": check_empty(dt_dd_dict["Note"]),
        }


def run_spider(links_file, start_index, end_index, target_csv):
    process = CrawlerProcess(settings={"FEED_URI": target_csv, "FEED_FORMAT": "csv"})
    process.crawl(ACLSpider, arguments=[links_file, start_index, end_index])
    process.start()
