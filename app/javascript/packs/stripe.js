// Javascript line to connect button action to stripe

const button = document.querySelector("[data-stripe='payment']");
const {sessionId, publicKey} = button.dataset
button.addEventListener('click', () => {
    const stripe = Stripe(publicKey);
    stripe.redirectToCheckout({sessionId: sessionId});
});