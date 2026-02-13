#include <iostream>
#include <vector>
#include <algorithm>
#include <memory>

namespace App::Utils {
    template <typename T>
    class Container {
    private:
        std::vector<T> data;
    public:
        void add(T item) { data.push_back(item); }
        
        auto find_match(T target) {
            return std::find_if(data.begin(), data.end(), [target](const T& item) {
                return item == target;
            });
        }
    };
}

int main() {
    auto store = std::make_unique<App::Utils::Container<int>>();
    store->add(42);
    
    if (store->find_match(42) != nullptr) {
        std::cout << "Match found!" << std::endl;
    }

    return 0;
}
