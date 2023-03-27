import os, sys, time

class Item:
    _name = ""
    _id = 0
    _price = 0
    _url = ""

class YoworldItems():
    items = []
    def __init__(self, item_search: str) -> None:
        __file = open("items.txt", "r")
        self.__data = __file.read()
        self.search = item_search
        __file.close()
        self.fetch_all_items()

        if isinstance(item_search, int):
            pass
        else:
            pass

    @staticmethod
    def create_item(name: str, iid: int, price: int, url: str) -> Item:
        i = Item()
        i._name = name
        i._id = iid
        i._price = price
        i._url = url
        return i

    def __parse(self, line: str) -> list:
        return line.replace("(", "").replace(")", "").replace("'", "").split(",")

    def fetch_all_items(self) -> bool:
        lines = self.__data.split("\n")

        for line in lines:
            if len(line) == 0 | len(line) < 10: continue

            item_info = self.__parse(line)
            self.items.append(create_item(item_info[0], int(item_info[1]), int(item_info[2]), item_info[3]))

        if len(self.items) > 0: return True
        return False

    def search_item_name(self) -> list:
        self.__found = []

        for item in self.items:
            no_case_sen = self.search.lower()

            if item._name == self.search: return [i]
            elif self.search.lower() in item._name: return [i]

            words_in_search = self.search.split(" ")
            for word in words_in_search:
                if word in item._name: 
                    self.__found.append(item)
                    break

        return self.__found

    def search_item_id(self) -> Item:
        for item in self.items:
            if f"{self.search}" in f"{item._id}": return item

        return create_item("", 0, 0, "")

