export interface GitHubButtonOptions {
  "href": string;
  "aria-label"?: string;
  "title"?: string;
  "data-icon"?: string;
  "data-size"?: string;
  "data-show-count"?: boolean;
  "data-text"?: string;
}

export function render(options: GitHubButtonOptions | HTMLAnchorElement, callback: (el: HTMLIFrameElement | HTMLSpanElement) => void): void;
