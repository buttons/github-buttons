github-button.component.ts
--------------------------

``` ts
// app.module.ts

import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent }          from './app.component';
import { GithubButtonComponent } from 'github-buttons/dist/angular/github-button.component';

@NgModule({
  imports: [
    BrowserModule
  ],
  declarations: [
    AppComponent,
    GithubButtonComponent
  ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
```

``` ts
// app.component.ts

import { Component } from '@angular/core';

@Component({
  selector: 'my-app',
  template: `
    <github-button href="{{ 'http://github.com/ntkme' }}"> Follow @ntkme </github-button>
  `
})
export class AppComponent { }
```
