import os
import net.http

fn main()
{
	items := (os.read_file("items.txt") or { "" }).split("\n")

	for item in items
	{
		if item.len == 0 || item.len < 10 { continue }

		if item[]
	}
}

fn parse_line(line string) []string
{
	return line.replace("(", "").replace(")", "").replace("'", "").split(",")
}