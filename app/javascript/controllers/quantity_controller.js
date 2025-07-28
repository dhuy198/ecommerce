import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  up() {
    const cartId = this.element.dataset.cartItemId;
    const params = {
      cart_id: cartId,
    };
    const options = {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch(`/api/v1/cart_items/${cartId}/increase`, options)
      .then((res) => {
        if (!res.ok) {
          throw Error(res.status);
        }
        return res.json();
      })
      .then((data) => {
        let sl = document.getElementById(`sl-${cartId}`);
        sl.innerText = data.cart_item_quantity;
        this.element.dataset.itemQuantity = data.cart_item_quantity;
        console.log(data);
      })
      .catch((e) => {});
  }

  down() {
    console.log(this.element.dataset.itemQuantity);
    const quantity = parseInt(this.element.dataset.itemQuantity);
    const cartId = this.element.dataset.cartItemId;
    if (quantity === 1) {
      const del = document.getElementById(`del-${cartId}`);
      del.click();
      return;
    }
    const params = {
      cart_id: cartId,
    };
    const options = {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch(`/api/v1/cart_items/${cartId}/decrease`, options)
      .then((res) => {
        if (!res.ok) {
          throw Error(res.status);
        }
        return res.json();
      })
      .then((data) => {
        let sl = document.getElementById(`sl-${cartId}`);
        sl.innerText = data.cart_item_quantity;
        this.element.dataset.itemQuantity = data.cart_item_quantity;
      })
      .catch((e) => {
        console.log(e);
      });
  }
}
