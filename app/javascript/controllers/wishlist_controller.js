import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];
  update() {
    if (this.element.dataset.status === "false") {
      const product_id = this.element.dataset.productId;
      const wishlist_id = this.element.dataset.wishlistId;
      this.add(wishlist_id, product_id);
    } else {
      const item_id = this.element.dataset.itemId;
      this.remove(item_id);
    }
  }

  add(wishlistId, productId) {
    const params = {
      wishlist_id: wishlistId,
      product_id: productId,
    };
    const options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch("/api/v1/wishlist_items", options)
      .then((res) => {
        if (!res.ok) {
          throw Error(res.status);
        }
        return res.json();
      })
      .then((data) => {
        this.element.classList.remove("fill-none");
        this.element.classList.add("fill-red-400");
        this.element.dataset.status = "true";
        this.element.dataset.itemId = data.id;
        let navbar = document.getElementById("wishlistCount");
        const cnt = navbar.dataset.wishlistCount;
        const newCount = parseInt(cnt) + 1;
        navbar.innerText = newCount;
        navbar.dataset.wishlistCount = newCount;

        console.log(data);
      })
      .catch((e) => {
        console.log(e);
      });
  }
  remove(item_id) {
    console.log("Deleting item with ID: ", item_id);

    fetch("/api/v1/wishlist_items/" + item_id, {
      method: "DELETE",
    })
      .then((res) => {
        if (!res.ok) {
          console.log(res.status);
        }
        return res.json();
      })
      .then((data) => {
        console.log(data);
        this.element.classList.remove("fill-red-400");
        this.element.classList.add("fill-none");
        this.element.dataset.status = "false";
        let navbar = document.getElementById("wishlistCount");
        const cnt = navbar.dataset.wishlistCount;
        const newCount = parseInt(cnt) - 1;
        navbar.innerText = newCount;
        navbar.dataset.wishlistCount = newCount;
        console.log(data);
      })
      .catch((e) => {
        console.log(e);
      });
  }
}
