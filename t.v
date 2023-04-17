import os
import x.json2
import net.http

const api_url = "https://yoworlddb.com/scripts/getItemInfo.php"

fn main()
{
	mut items := (os.read_file("items.txt") or { "" }).split("\n")
	mut new_db := ""
	for item in items
	{
		if item.len == 0 || item.len < 10 { continue }
		info := parse_line(item)
		item_info := http.post_form(api_url, {'iid': "${info[1]}"}) or { http.Response{} }
		mut item_price := info[3]
		if item_price == "0" {
			if item_info.body.starts_with("{") && item_info.body.ends_with("}") 
			{
				json_obj := (json2.raw_decode(item_info.body) or { json2.Any{} }).as_map()
				value := (json2.raw_decode("${json_obj['response']}") or { json2.Any{} }).as_map()
				instore_check := "${value['active_in_store']}"
				if instore_check != "0" {
					item_price = "${value['price_coins']}"
					if (item_price == "0" || item_price == "") && "${value['price_cash']}" != "0" {
						item_price = "${value['price_cash']}yc"
					} 
					print("\x1b[92mNew In-Store Price ${item_price}\x1b[0m\n")
				}
			}
		}
		new_db += "('${info[0]}','${info[1]}','${info[2]}','${info[3]}')"
		print("Item: ${info[0]} | ${info[1]} | ${item_price}\n")
	}
	os.write_file("t.txt", new_db) or {return}
}

fn parse_line(line string) []string
{
	return line.replace("(", "").replace(")", "").replace("'", "").split(",")
}
