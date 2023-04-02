import os
import net.http

pub struct GoogleDriveScrape
{
	pub mut:
		data		string
		lines		[]string
		loop		int = 0
}

fn main()
{
	mut s := scrape_google_drive()
	s.lines = s.data.split("\n")

	for {
		if s.loop == s.lines.len || s.loop > s.lines.len { break }
		line := s.lines[s.loop]
		println("Item Name: ${line}")
		s.loop+=3
	}
}

pub fn scrape_google_drive() GoogleDriveScrape
{
	mut g := GoogleDriveScrape{}
	guide := http.get_text("https://docs.google.com/spreadsheets/d/e/2PACX-1vQRR3iveCH4Y1pdxWCAzW7qchTlHYzvlNG6e6ZyMKn2vjodu8-uLSoAHSLMq1X3qA/pubhtml")
	lines := guide.split(">")
	for line in lines
	{
		if line.contains("</td")
		{
			new_value := line.replace("</td", "")
			if new_value.len > 0 {
				g.data += "${new_value}\n"
			}
		}
	}
	return g
}