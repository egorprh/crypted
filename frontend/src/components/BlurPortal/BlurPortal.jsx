import { useEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";

export default function BlurPortal({ children, className }) {
    const [mounted, setMounted] = useState(false);
    const containerRef = useRef(null);

    if (!containerRef.current) {
        containerRef.current = document.createElement("div");
    }

    useEffect(() => {
        const el = containerRef.current;
        el.setAttribute("data-blur", "true");

        if (className) {
            el.className = className;
        }

        const prevOverflow = document.body.style.overflow;
        document.body.style.overflow = "hidden";

        document.body.appendChild(el);
        setMounted(true);

        return () => {
            document.body.style.overflow = prevOverflow;
            document.body.removeChild(el);
        };
    }, []);

    if (!mounted) return null;
    return createPortal(children, containerRef.current);
}
