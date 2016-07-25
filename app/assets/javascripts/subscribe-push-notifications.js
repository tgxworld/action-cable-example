var sendSubscriptionToServer = function(subscription) {
  $.ajax({
    url: '/push_notifications/subscribe',
    type: 'POST',
    data: { subscription: subscription.toJSON() }
  });
}

var isPushNotificationsSupported = function() {
  if (!(('serviceWorker' in navigator) &&
     (ServiceWorkerRegistration &&
     ('showNotification' in ServiceWorkerRegistration.prototype) &&
     ('PushManager' in window)))) {

    return false;
  }

  return true;
}

var register = function() {
  if (!isPushNotificationsSupported()) return;

  navigator.serviceWorker.register('/push-service-worker.js').then(function() {
    if (Notification.permission === 'denied') return;

    navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
      serviceWorkerRegistration.pushManager.getSubscription().then(function(subscription) {
        if (subscription) {
          sendSubscriptionToServer(subscription);
          // Resync localStorage
          localStorage.setItem('chatty-push-notifications', 'subscribed');
        }
      }).catch(function(e) {
        console.log(e);
      });
    });
  });
}

var subscribe = function() {
  if (!isPushNotificationsSupported()) return;

  navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
    serviceWorkerRegistration.pushManager.subscribe({ userVisibleOnly: true }).then(function(subscription) {
      sendSubscriptionToServer(subscription);
      localStorage.setItem('chatty-push-notifications', 'subscribed');
    }).catch(function(e) {
      console.log(e);
    });
  });
}

var unsubscribe = function() {
  if (!isPushNotificationsSupported()) return;

  navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
    serviceWorkerRegistration.pushManager.getSubscription().then(function(subscription) {
      if (subscription) {
        subscription.unsubscribe().then(function(successful) {
          if (successful) {
            $.ajax({
              url: '/push_notifications/unsubscribe',
              type: 'POST',
              data: { subscription: subscription.toJSON() }
            });

            localStorage.setItem('chatty-push-notifications', '');
          }
        });
      }
    }).catch(e => Ember.Logger.error(e));
  });
}
