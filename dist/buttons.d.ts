declare module "github-buttons" {
  export function render(options: {
    "href": string;
    "aria-label"?: string;
    "title"?: string;
    "data-icon"?: string;
    "data-size"?: string;
    "data-show-count"?: boolean;
    "data-text"?: string;
  } | HTMLAnchorElement, callback: (el: HTMLIFrameElement | HTMLSpanElement) => void): void;
}
