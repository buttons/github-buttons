import { Component, Input, ElementRef, OnChanges, AfterViewChecked } from '@angular/core'

import { render } from 'github-buttons'

@Component({
  selector: 'github-button',
  template: `<a [href]="href" [attr.data-icon]="dataIcon" [attr.data-size]="dataSize" [attr.data-show-count]="dataShowCount" [attr.data-text]="dataText" [attr.aria-label]="ariaLabel"><ng-content></ng-content></a>
  `
})
export class GithubButtonComponent implements OnChanges, AfterViewChecked {
  @Input() href: string = ""
  @Input('data-icon') dataIcon: string
  @Input('data-size') dataSize: string
  @Input('data-show-count') dataShowCount: string
  @Input('data-text') dataText: string
  @Input('aria-label') ariaLabel: string

  private _: Node

  constructor(private el: ElementRef) {}

  ngOnChanges() {
    this._ && this.el.nativeElement.replaceChild(this._, this.el.nativeElement.firstChild) && (this._ = null)
  }

  ngAfterViewChecked() {
    this._ || render(this._ = this.el.nativeElement.firstChild)
  }
}
