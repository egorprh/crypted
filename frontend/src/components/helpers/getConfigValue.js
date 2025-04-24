export default function getConfigValue(config, name) {
    const item = config.find((c) => c.name === name);
    return item ? item.value : null;
}