/*
	YoworldDB Item Scraper Using Web Page & API

	Created in V due to performance

	@author: ArroGant SnF
	@since: 3/25/23
*/
import os
import x.json2
import net.http

pub const (
	yoworlddb_items_url = "https://yoworlddb.com/items/page/"
	yoworlddb_item_info_url = "https://yoworlddb.com/scripts/getItemInfo.php"
)

pub struct Item {
	pub mut:
		name				string
		id					int
		price				string
		img_url				string
}

pub struct Scrape
{
	pub mut:
		data				string
		items				[]Item
		
		page_count			int

		page				int
		count				int
		items_per_page		int
}

pub fn start_scraper() Scrape
{
	mut s := Scrape{}
	check_pages := http.get_text(yoworlddb_items_url)
	for page in check_pages.split("\n")
	{
		if page.contains("</select>") && s.page_count > 4000 { break }
		if check_pages.trim_space().contains("option value=") {	s.page_count = page.trim_space().replace("<option value=\"", "").replace(" >", "").replace("</option>", "").split("\"")[0].int() }
	}

	if s.page_count == 0 {
		print("[ x ] Error, Unable to get max pages of items...!\n")
		exit(0)
	}

	print("[ + ] Scraping ${s.page_count} pages....!\n")
	return s
}

pub fn (mut s Scrape) scrape()
{
	for i in 0..s.page_count
	{
		s.page = i
		page_content := http.get_text("${yoworlddb_items_url}${i}")
		s.scrape_page(page_content)
	}
}

pub fn (mut s Scrape) scrape_page(content string)
{
	page_lines := content.split("\n")

    mut c := 0
    mut item_name := ""
    mut item_id := 0
    mut item_image := ""
    mut item_price := ""
	mut info := false
	mut all_info := false

    mut item_count := 0
    for line in page_lines
    {
		info = false
            if line.contains("<a class=\"item-image\"")
            {
                    item_id = line.split("data")[1].replace("=\"", "").replace("\"></a>", "").split("/")[3].replace(".gif", "").replace("_60_60", "").int()
                    item_image = "https://yw-web.yoworld.com/cdn/items/" + line.trim_space().split("data=\"")[1].replace("\"></a>", "")
                    item_name = page_lines[c+2].replace("</a>", "").trim_space().replace("~ ", "").replace("'", "").replace(",", "")
            }

            if item_name != "" && item_id > 0 && item_image != ""
			{
					check := http.post_form(yoworlddb_item_info_url, {'iid': "${item_id}"}) or { http.Response{} }
					if check.body.starts_with("{") && check.body.ends_with("}") 
					{
						json_obj := (json2.raw_decode(check.body) or { json2.Any{} }).as_map()
						// resp := (json2.raw_decode("${json_obj['response']}") or { json2.Any{} }).as_map()
						value := (json2.raw_decode("${json_obj['values']}") or { json2.Any{} }).as_map()
						item_price = "${value['estimated_price']}"
						info = true
						if info == false { all_info = false }
					}

                    s.items << (Item{name: item_name, id: item_id, img_url: item_image, price: item_price})
                    s.data += "('${item_name}','${item_id}','${item_image}','${item_price}')\n"
					print("#${item_count}: ${item_name} | ${item_id} | ${item_image} | ${item_price}\n")
                    item_name = ""
                    item_id = 0
                    item_image = ""
                    item_count++
            }
            c++
    }
	print("Page ${s.page} completed with ${item_count} | Recieved Item Info: ${all_info}....!\n")
}

fn main() {
	mut s := start_scraper()
	s.scrape()
	os.write_file("test.txt", s.data) or { return }
}