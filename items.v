import os

pub struct Item {
	pub mut:
		name				string
		id					int
		price				string
		img_url				string
}

pub struct ItemEngine 
{
	pub mut:
		item_db		string
		items		[]Item
		search		string

		item_found	Item
		items_found	[]Item
}

pub fn engine_init(q string) ItemEngine
{
	mut eng := ItemEngine{search: q}
	eng.item_db = os.read_file("items.txt") or { "" }

	if eng.item_db.len < 10 { 
		print("[!] Item database is empty....!\n")
		return
	}

	eng.fetch_all_items()
	return eng
}

pub fn (mut eng ItemEngine) new_search(q string)
{ eng.search = q }

pub fn (mut eng ItemEngine) create_item(n string, iid int, p int, url string) Item
{ return Item{name: n, id: iid, price: p, img_url: url} }

pub fn (mut eng ItemEngine) parse(line string) []string 
{ return line.replace("(", "").replace(")", "").replace("'", "").split(",") }

pub fn (mut eng ItemEngine) fetch_all_items() bool
{
	lines := eng.item_db.split("\n")

	for line in lines
	{
		if line.len == 0 || lines.lem < 10 { continue }

		info := eng.parse(line)
		eng.items << eng.create_item(info[0], info[1].int(), info[3].int(), info[2])
	}

	if eng.items.len > 0 { return true }
	return false
}

pub fn (mut eng ItemEngine) search_item_name() []Item
{
	for item in eng.items
	{
		no_case_sen := eng.search.to_lower()

		if item.name == eng.search { return eng.item_found = item }
		else if (item.name.to_lower()).contains(no_case_sen) { return eng.item_found = item }

		words_in_search := eng.search.split(" ")
		for word in words_in_search
		{
			if (item.name.to_lower()).contains(word.to_lower())
			{
				eng.items_found << item
				break
			}
		}
	}

	if eng.item_found != Item{} { return [eng.item_found] }
	return eng.items_found
}

pub fn (mut eng ItemEngine) search_item_id() Item
{
	for item in eng.items 
	{
		if "${eng.search}" in "${item.id}" { return item }
	}

	return Item{}
}