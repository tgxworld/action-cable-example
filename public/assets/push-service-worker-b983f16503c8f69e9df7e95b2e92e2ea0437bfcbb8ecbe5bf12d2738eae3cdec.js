'use strict';

function showNotification(title, body, icon, tag, url) {
  var notificationOptions = {
    body: body,
    icon: icon,
    data: { url: url },
    tag: tag
  }

  return self.registration.showNotification(title, notificationOptions);
}

self.addEventListener('push', function(event) {
  var payload = event.data.json();

  event.waitUntil(
    self.registration.getNotifications({ tag: payload.tag }).then(function(notifications) {
      if (notifications && notifications.length > 0) {
        notifications.forEach(function(notification) {
          notification.close();
        });
      }

      return showNotification(payload.title, payload.body, payload.icon, payload.tag, payload.url);
    })
  );
});

self.addEventListener('notificationclick', function(event) {
  // Android doesn't close the notification when you click on it
  // See: http://crbug.com/463146
  event.notification.close();
  var url = event.notification.data.url;

  // This looks to see if the current window is already open and
  // focuses if it is
  event.waitUntil(
    clients.matchAll({ type: "window" })
      .then(function(clientList) {
        clientList.forEach(function(client) {
          if (client.url === url && 'focus' in client) return client.focus();
        });

        if (clients.openWindow) return clients.openWindow(url);
      })
  );
});
