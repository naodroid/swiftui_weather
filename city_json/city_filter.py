import json

# open-weather's city list file is too large. it containts about 210,000 cities.
# So this program reduces data. about 1 tenth
# How To use
# 1. download city.list.min.json.gz from
#   http://bulk.openweathermap.org/sample/
# 2. put it into this folder and extract it
# 3. run code:  python3 city_filter.py
# 4. city_list.json will be created
# 5. copy it to sui_sample/asset

def reduce_cities():
    with open("city.list.min.json", "rb") as json_file:
        cities = json.load(json_file)

        reduced = list()
        for (i, k) in enumerate(cities):
            if i % 10 == 0:
                reduced.append(k)

        # if you want to filter by country, use following code
        reduced = [city for city in cities if city["country"] == "JP"]

        print("number of cities:" + str(len(reduced)))
        with open("city_list.json", "w") as jp_file:
            json.dump(reduced, jp_file)


if __name__ == "__main__":
    reduce_cities()
