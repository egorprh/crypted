export default function handleImageError(imagePath = '/images/default-event.png') {
    return function (e) {
        e.target.src = imagePath;
        e.target.onerror = null;
    };
}