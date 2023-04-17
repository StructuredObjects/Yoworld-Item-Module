import os, sys, time, subprocess, datetime

class Item:
    _name = ""
    _id = 0
    _price = ""
    _url = ""
    _lastupdate = ""

class YoworldItems():
    items = []

    match_found = Item()
    match_found_tog = False

    closest_match_found = Item()
    closest_match_found_tog = False 

    possible_match_found = []
    possible_match_found_tog = False
    def __init__(self, item_search: str) -> None:
        self.search = item_search
        self.update()

        if isinstance(item_search, int):
            pass
        else:
            pass

    def update(self) -> None:
        __file = open("items.txt", "r")
        self.__data = __file.read()
        __file.close()
        self.fetch_all_items()

    @staticmethod
    def create_item(name: str, iid: int, price: str, url: str, update: str) -> Item:
        i = Item()
        i._name = name
        i._id = iid
        i._price = price
        i._url = url
        i._lastupdate = update
        return i

    def __parse(self, line: str) -> list:
        return line.replace("(", "").replace(")", "").replace("'", "").split(",")


    def fetch_all_items(self) -> bool:
        self.items = []
        self.found = []
        lines = self.__data.split("\n")

        for line in lines:
            if len(line) == 0 | len(line) < 10: continue

            item_info = self.__parse(line)
            self.items.append(self.create_item(item_info[0], int(item_info[1]), item_info[3], item_info[2], item_info[4]))

        if len(self.items) > 0: return True
        return False

    def search_item_name(self) -> list:
        self.possible_match_found = []
        self.possible_match_found_tog = False
        self.match_found_tog = False
        self.possible_match_found_tog = False
        for item in self.items:
            no_case_sen = self.search.lower()

            if item._name == self.search and self.match_found_tog == False: 
                self.match_found = item
                self.match_found_tog = True

            elif no_case_sen in item._name.lower():
                self.closest_match_found = item
                self.closest_match_found_tog = True

            if " " in no_case_sen:
                words = no_case_sen.split(" ")
                loop_c = False
                c = 0
                for word in words:
                    if word in item._name.lower(): 
                        loop_c = True

                    if loop_c and c == len(words)-1: 
                        self.possible_match_found_tog = True
                        self.possible_match_found.append(item)
                    c+=1

        return self.possible_match_found

    def search_item_id(self) -> Item:
        for item in self.items:
            if f"{self.search}" in f"{item._id}": return item

        return self.create_item("", 0, 0, "", "")

    def set_new_price(self, item_id: int, new_price: int) -> bool:
        items = ""
        found = False
        time = datetime.datetime.now()
        for i in self.items:
            if f"{i._id}" == f"{item_id}":
                items += f"('{i._name}','{i._id}','{i._url}','{new_price}','{time}')\n"
            else:
                items += f"('{i._name}','{i._id}','{i._url}','{i._price}','{i._lastupdate}')\n"

        new_db = open("items.txt", "w")
        new_db.write(items)
        new_db.close()
        subprocess.getoutput("sudo cp items.txt /var/www/html/items.txt")
        return True