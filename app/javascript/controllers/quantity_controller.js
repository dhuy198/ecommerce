import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  up() {
    const stock = this.element.dataset.stock;
    const itemQuantity = this.element.dataset.itemQuantity;

    if (stock === itemQuantity) {
      return;
    }
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
        const totalItem = document.getElementById(`totalItem-${cartId}`);
        const total1 = document.getElementById("total1");
        const total2 = document.getElementById("total2");
        const tax = document.getElementById("tax");
        sl.innerText = data.cart_item_quantity;
        this.element.dataset.itemQuantity = data.cart_item_quantity;
        totalItem.innerText = `$${Number(data.total_item).toFixed(2)}`;
        total1.innerText = `$${Number(data.total).toFixed(2)}`;
        tax.innerText = `$${Number(
          (data.total * tax.dataset.tax) / 100
        ).toFixed(2)}`;
        total2.innerText = `$${Number(
          data.total * (1 + tax.dataset.tax / 100)
        ).toFixed(2)}`;
      })
      .catch((e) => {});
  }

  down() {
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
        const totalItem = document.getElementById(`totalItem-${cartId}`);

        sl.innerText = data.cart_item_quantity;
        this.element.dataset.itemQuantity = data.cart_item_quantity;
        totalItem.innerText = `$${Number(data.total_item).toFixed(2)}`;
        const total1 = document.getElementById("total1");
        const total2 = document.getElementById("total2");
        const tax = document.getElementById("tax");
        total1.innerText = `$${Number(data.total).toFixed(2)}`;
        tax.innerText = `$${Number(
          (data.total * tax.dataset.tax) / 100
        ).toFixed(2)}`;
        total2.innerText = `$${Number(
          data.total * (1 + tax.dataset.tax / 100)
        ).toFixed(2)}`;
      })
      .catch((e) => {
        console.log(e);
      });
  }
}
