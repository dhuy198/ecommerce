import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  pay() {
    const userId = this.element.dataset.userId;
    const params = {
      user_id: userId,
    };
    const options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch("/api/v1/orders", options)
      .then((res) => {
        if (!res.ok) {
          throw Error(res.status);
        }
        return res.json();
      })
      .then((data) => {
        console.log(data);
      })
      .catch((e) => {
        console.log(e);
      });
  }
}
